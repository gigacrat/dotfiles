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

-- Column width for these, as a fraction of the monitor. 0.5 is deliberately the
-- first entry in scrolling.explicit_column_widths (looknfeel.lua), so one opens
-- at half width and SUPER+O toggles it straight to full.
--
-- Fraction only. A pixel value here is not clamped or rejected: 820 failed to
-- map the window at all and pushed the scroll offsets past 600,000, and a
-- negative gave a column 3px wide.
local popup_width = 0.5

if tile_omarchy_floats then
  o.window({ tag = "floating-window" }, { tile = true, scrolling_width = popup_width })

  -- Omarchy floats some apps with a direct class rule rather than the tag
  -- above, so the tag rule never reaches them (default/hypr/apps/system.lua).
  -- These are ordinary resizable windows that fill a column cleanly, so they
  -- get the same treatment instead of being left as exceptions.
  --
  -- The genuine overlays in that group stay floating on purpose: PiP and the
  -- webcam overlay are pinned, the screensaver is fullscreen, and a tiled
  -- column is the wrong shape for all three.
  o.window("^omacalc$", { tile = true, scrolling_width = popup_width })

  -- Opt individual apps back out as you hit them, e.g.:
  -- o.window("org.gnome.NautilusPreviewer", { float = true })
  --
  -- Note a width set per class only lands on windows the tag does not cover,
  -- which is why it works above. A tag-matched rule beats a class-matched one
  -- for this property whatever the file order, because tags are assigned while
  -- rules are still being processed -- so a class width cannot override the tag
  -- rule, only fill in where it does not apply.
end

-- Windows that float on their own initiative are not covered by the tag above.
-- Hyprland floats toplevels that declare a parent, which is how most Electron
-- and GTK modals arrive; a parentless window tiles normally.
--
-- Catching those would need a STATIC match -- class, title or tag. There is no
-- generic one: the compositor has no "is a dialog" match, and matching
-- `float = true` cannot drive placement, because a window only satisfies that
-- match once something has already floated it, so the rule is evaluated after
-- placement is settled and `tile` is discarded. The match itself does fire --
-- a tag payload lands fine -- which makes it look like a precedence bug rather
-- than an ordering one. Omarchy uses the static form for Chromium/Electron
-- popups in default/hypr/apps/browser.lua.
--
-- So anything not covered by the tag is left to float, deliberately. Tiling it
-- instead would mean naming the app, and often a measured width alongside:
-- whether a column helps at all depends on the client. One that negotiates its
-- size fills the column; one that hard-codes its geometry does not, and the
-- layout just stretches the frame while the client keeps painting its own size,
-- leaving desktop visible inside the window.
--
-- Some of those hard-coded sizes are too small for the app's own content, which
-- floating then shows cropped. Nothing here can fix that: the size is the
-- client's decision, a `size` rule and `no_max_size` are both ignored, and
-- Hyprland exposes no way to read what the window actually wants -- there are
-- no min/max size fields in the Lua API or in `hyprctl clients`. That makes it
-- an app bug rather than a config gap, and it belongs upstream.
