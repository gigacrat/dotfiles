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
  -- scrolling_width is a fraction of the monitor, and 0.5 is deliberately the
  -- first entry in scrolling.explicit_column_widths (looknfeel.lua), so a popup
  -- opens at half width and SUPER+O toggles it straight to full.
  --
  -- Fraction only. A pixel value here is not clamped or rejected: 820 failed to
  -- map the window at all and pushed the scroll offsets past 600,000, and a
  -- negative gave a column 3px wide.
  o.window({ tag = "floating-window" }, { tile = true, scrolling_width = 0.5 })

  -- Opt individual apps back out of the experiment as you hit them, e.g.:
  -- o.window("org.gnome.NautilusPreviewer", { float = true })
  --
  -- Per-app widths do NOT work alongside the rule above -- a tag-matched rule
  -- beats a class-matched one for this property whatever the file order, since
  -- tags are assigned while rules are still being processed. To vary width by
  -- app, drop scrolling_width from the tag rule and set it per class instead.
end

-- Apps that float on their own initiative are not covered by the tag above.
-- Hyprland floats toplevels that declare a parent, which is how Electron and
-- GTK modals arrive; a plain parentless window tiles normally (pinentry-gtk
-- does, for instance).
--
-- These have to be matched on a STATIC property -- class, title or tag.
-- Matching `float = true` reads like the obvious way to catch "whatever is
-- floating", but it cannot work for placement: a window only satisfies that
-- match once something has already floated it, so the rule is evaluated after
-- placement is settled and `tile` is discarded. The match itself does fire --
-- a tag payload lands fine -- which makes it look like a precedence bug rather
-- than an ordering one. Omarchy leans on the static form for Chromium/Electron
-- popups in default/hypr/apps/browser.lua.
--
-- Obsidian's vault switcher is deliberately left floating; do not add a `tile`
-- rule for it. The window is fixed-size -- it reports 820x670 and refuses every
-- resize, floating or tiled -- so tiling only stretches the frame while the
-- client keeps painting 820x670, leaving desktop visible inside the window.
--
-- Worth checking before tiling any popup. Focus it while it is still floating,
-- then ask for a size it cannot have:
--   hyprctl dispatch 'hl.dsp.window.resize({ x = 1200, y = 900 })'
-- If hyprctl clients still reports the old size, the window is fixed and does
-- not belong in the scroll.
