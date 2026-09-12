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
hl.unbind(mainMod .. " + H")
hl.unbind(mainMod .. " + L")
o.bind(mainMod .. " + H", "Focus column left", hl.dsp.focus({ direction = "left" }))
o.bind(mainMod .. " + L", "Focus column right", hl.dsp.focus({ direction = "right" }))

-- Swap the current column left/right.
-- Was: SUPER+J "Toggle window split", SUPER+K "Keybindings".
hl.unbind(mainMod .. " + J")
hl.unbind(mainMod .. " + K")
o.bind(mainMod .. " + J", "Swap column right", hl.dsp.layout("swapcol r"))
o.bind(mainMod .. " + K", "Swap column left", hl.dsp.layout("swapcol l"))

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

-- Toggle the "scratch" special workspace.
-- Was: SUPER+RETURN "Terminal" (still available on SUPER+ALT+RETURN as Tmux).
hl.unbind(mainMod .. " + RETURN")
o.bind(mainMod .. " + RETURN", "Toggle second screen", hl.dsp.workspace.toggle_special("scratch"))

-- Move the active window between the current and the other workspace.
o.bind(
  mainMod .. " + semicolon",
  "Toggle window workspace",
  (os.getenv("HOME") or "") .. "/.config/hypr/scripts/toggle_window_workspace.sh"
)

-- Escape hatch for windows.lua, which tiles Omarchy's floating windows into
-- the scroll. When something genuinely wants to float, this pops it out:
-- float + resize + center + pin + raise. SUPER+T still does the plain
-- float/tile toggle without the geometry. On SHIFT because SUPER+O now cycles
-- column width.
--
-- Size is left to the script. It accepts [width height x y], but in logical
-- pixels -- on a scaled monitor those are fewer than the panel resolution, and
-- an override past them puts the window partly off-screen.
o.bind(mainMod .. " + SHIFT + T", "Pop window out (float & pin)", "omarchy-hyprland-window-pop")
