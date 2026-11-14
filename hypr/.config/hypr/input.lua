-- Personal input overrides, loaded after Omarchy's defaults.
-- Commented examples of other options: /usr/share/omarchy/config/hypr/input.lua

-- https://wiki.hypr.land/configuring/core/config-options/#input
hl.config({
  input = {
    -- Swap Caps Lock and Escape; Right Alt is the Compose key.
    kb_options = "caps:swapescape,compose:ralt",
    repeat_delay = 600,

    -- Don't automatically focus windows on mouse hover.
    follow_mouse = 0,

    -- When the focused window closes, focus the most recently used window.
    focus_on_close = 2,
  },
})

-- https://wiki.hypr.land/configuring/core/config-options/#cursor
hl.config({
  cursor = {
    -- Don't warp the cursor to center when focusing windows with the keyboard.
    no_warps = true,
  },
})
