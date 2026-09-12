-- Return focus to the previously focused window when a window closes.
--
-- Hyprland's `input:focus_on_close` offers only 0 (next candidate, by layout
-- adjacency) and 1 (window under the cursor). Neither is "the window I was on
-- before", so on a scrolling layout dismissing a popup lands on whichever
-- column happens to sit next in the scroll instead of where you were.
--
-- No stack needed: Hyprland already keeps a focus history -- every window
-- carries a focus_history_id, 0 being active -- and hl.get_last_window() reads
-- the entry just behind it. Nested popups unwind correctly for the same reason.

local return_focus_on_close = true

-- Long enough for Hyprland's own on-close focus pick to land first, short
-- enough to be invisible. Focusing synchronously in the handler below would
-- just be overwritten by that pick.
local settle_ms = 40

if return_focus_on_close then
  hl.on("window.close", function(window)
    -- Closing a window that wasn't focused shouldn't move focus at all.
    if not (window and window.active) then
      return
    end

    local previous = hl.get_last_window()
    if not previous then
      return
    end

    -- Staying on one workspace keeps a dismissed popup from yanking the view
    -- somewhere else.
    local from = window.workspace and window.workspace.id
    local to = previous.workspace and previous.workspace.id
    if from and to and from ~= to then
      return
    end

    local selector = "address:" .. previous.address

    hl.timer(function()
      -- The target may itself be gone by now (closing a parent takes its
      -- dialogs with it), so re-check before focusing.
      if hl.get_window(selector) then
        hl.dispatch(hl.dsp.focus({ window = selector }))
      end
    end, { timeout = settle_ms, type = "oneshot" })
  end)
end
