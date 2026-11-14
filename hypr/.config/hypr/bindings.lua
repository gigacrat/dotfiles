-- Keep only your personal keybinding overrides here. Add new bindings or
-- unbind defaults before replacing them.

-- See current bindings and descriptions:
--   omarchy menu keybindings --print

-- To disable every Omarchy default binding, set this in
-- ~/.config/hypr/hyprland.lua before require("default.hypr.omarchy"), then add
-- only the bindings you want below:
--   omarchy_default_bindings = false

-- To disable all preinstalled app/webapp bindings, set:
--   omarchy_preinstalled_bindings = false

-- Add a new binding.
-- o.bind("SUPER + SHIFT + R", "SSH", "alacritty -e ssh your-server")

-- Change an existing binding by unbinding it first, then binding the key again.
-- This example changes SUPER+SPACE from the launcher to the Omarchy root menu.
-- hl.unbind("SUPER + SPACE")
-- o.bind("SUPER + SPACE", "Omarchy menu", "omarchy-menu toggle root")

-- Disable a default binding without replacing it.
-- hl.unbind("SUPER + SHIFT + B")

-- Logitech MX Keys examples:
-- o.bind("SUPER + SHIFT + S", nil, "omarchy-capture-screenshot")
-- o.bind("SUPER + H", nil, "voxtype record toggle")
-- o.bind("SUPER + PERIOD", nil, "omarchy-shell shell toggle omarchy.emojis")

local mainMod = "SUPER"

-- Move focus between columns with H/L.
-- Was: SUPER+L "Cycle workspace layout". SUPER+H was unbound.
hl.unbind(mainMod .. " + L")
o.bind(mainMod .. " + H", "Focus column left", hl.dsp.focus({ direction = "left" }))
o.bind(mainMod .. " + L", "Focus column right", hl.dsp.focus({ direction = "right" }))

-- Swap the current column left/right, on SHIFT of the focus keys above.
o.bind(mainMod .. " + SHIFT + H", "Swap column left", hl.dsp.layout("swapcol l"))
o.bind(mainMod .. " + SHIFT + L", "Swap column right", hl.dsp.layout("swapcol r"))

-- Omarchy binds SUPER+J to "Toggle window split", which is a dwindle message.
-- The scrolling layout has no such message and rejects it outright:
--   error: no such layoutmsg for scrolling
hl.unbind(mainMod .. " + J")

-- Toggle the active window between half and full screen width. The two sizes
-- come from scrolling.explicit_column_widths in looknfeel.lua.
-- Was: SUPER+O "Pop window out (float & pin)".
hl.unbind(mainMod .. " + O")
o.bind(mainMod .. " + O", "Toggle half/full width", hl.dsp.layout("colresize +conf"))

-- Switch to the next/previous workspace.
-- Was: SUPER+P "Pseudo window". SUPER+N was unbound.
hl.unbind(mainMod .. " + P")
o.bind(mainMod .. " + N", "Next workspace", hl.dsp.focus({ workspace = "+1" }))
o.bind(mainMod .. " + P", "Previous workspace", hl.dsp.focus({ workspace = "-1" }))

-- Move the active window to the next/previous workspace.
-- Was: SUPER+SHIFT+N "Editor", SUPER+SHIFT+P "Google Photos".
hl.unbind(mainMod .. " + SHIFT + N")
hl.unbind(mainMod .. " + SHIFT + P")
o.bind(mainMod .. " + SHIFT + N", "Move window to next workspace", hl.dsp.window.move({ workspace = "+1" }))
o.bind(mainMod .. " + SHIFT + P", "Move window to previous workspace", hl.dsp.window.move({ workspace = "-1" }))

-- The "scratch" special workspace: a hidden workspace shown over the current
-- one. SUPER+RETURN shows/hides it; SUPER+semicolon moves the active window
-- into it, or back out to the regular workspace.
-- Was: SUPER+RETURN "Terminal". No key opens a plain terminal now;
-- SUPER+ALT+RETURN still opens one running tmux.
local scratch = "scratch"
hl.unbind(mainMod .. " + RETURN")
o.bind(mainMod .. " + RETURN", "Toggle scratch workspace", hl.dsp.workspace.toggle_special(scratch))
o.bind(
  mainMod .. " + semicolon",
  "Move window to/from scratch",
  (os.getenv("HOME") or "") .. "/.config/hypr/scripts/toggle_scratch_window.sh " .. scratch
)
