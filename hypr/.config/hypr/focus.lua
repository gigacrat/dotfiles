-- Return focus to the previously focused window when a window closes.
--
-- Hyprland's `input:focus_on_close` only offers 0 (next window candidate, by
-- layout adjacency) and 1 (window under the cursor). Neither is "the window I
-- was on before". On a scrolling layout that shows up as: focus a column, let a
-- popup open a new column, dismiss it, and land on whichever column happens to
-- sit next in the scroll instead of where you were.
--
-- No stack needed -- Hyprland already keeps a focus history (every window
-- carries a focus_history_id, 0 being active) and hl.get_last_window() reads
-- the entry just behind the active one. This hooks window.close, remembers that
-- window, and re-focuses it once the close has settled.
--
-- The re-focus is deferred by a timer on purpose. Hyprland runs its own
-- on-close focus pick after this event fires, so focusing synchronously here
-- would just get overwritten.

local return_focus_on_close = true

-- Milliseconds to wait before restoring focus. Long enough for Hyprland's own
-- on-close focus pick to land first, short enough to be invisible.
local settle_ms = 40

if return_focus_on_close then
  hl.on("window.close", function(window)
    -- Closing a window that wasn't focused shouldn't move focus at all.
    if not (window and window.active) then
      return
    end

    -- Uncomment to limit this to Omarchy's popup-ish apps rather than every
    -- window. The tag survives windows.lua tiling them, so it still matches.
    -- local tags = window.tags
    -- if type(tags) == "table" then
    --   local popup = false
    --   for _, tag in ipairs(tags) do
    --     if tostring(tag):find("floating-window", 1, true) then popup = true end
    --   end
    --   if not popup then return end
    -- end

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
