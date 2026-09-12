-- Window rules.
--
-- Omarchy tags a broad set of apps "floating-window" and then forces each one
-- to float, centered, at exactly 875x600:
--
--   o.window({ tag = "floating-window" }, { float = true })
--   o.window({ tag = "floating-window" }, { center = true })
--   o.window({ tag = "floating-window" }, { size = { 875, 600 } })
--
-- (/usr/share/omarchy/default/hypr/apps/system.lua)
--
-- That fits a stacking workflow but fights the scrolling layout two ways.
-- Floating windows always render above tiled ones in Hyprland -- there is no
-- z-order mixing -- so they read as "always on top". And 875x600 crops any UI
-- that needs more room, with only relative resize keys to dig back out.
--
-- Overriding with `tile` folds them into the scroll as ordinary columns. The
-- center/size rules above stay in Omarchy's defaults but go inert, because the
-- layout owns a tiled window's geometry.
--
-- Affects: btop, the Omarchy terminal/bash, foot, Nautilus previewer, Evince,
-- imv, mpv, Bitwarden, 1Password, xdg-desktop-portal-gtk (every GTK file
-- picker), and the sublime/DesktopEditors/Nautilus open-save dialogs.
--
-- Set to false and `hyprctl reload` to get Omarchy's behaviour back.
local tile_omarchy_floats = true

if tile_omarchy_floats then
  o.window({ tag = "floating-window" }, { tile = true })

  -- Opt individual apps back out of the experiment as you hit them, e.g.:
  -- o.window("org.gnome.NautilusPreviewer", { float = true })
end

-- Apps that float on their own initiative are not covered by the tag above --
-- Hyprland auto-floats XDG toplevels that declare a parent, which is how most
-- Electron and GTK modals arrive. Tile them by class as you run into them:
-- o.window({ class = "md.obsidian.Obsidian", float = true }, { tile = true })
