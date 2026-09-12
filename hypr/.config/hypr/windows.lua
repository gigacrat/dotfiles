-- Overrides for Omarchy's window rules; see
-- /usr/share/omarchy/default/hypr/apps/ for what those set.
--
-- Omarchy tags a broad set of apps "floating-window" and forces each to float,
-- centered, at a fixed size. That suits a stacking workflow but fights the
-- scrolling layout: floating windows always render above tiled ones in Hyprland
-- -- there is no z-order mixing -- so they read as "always on top", and the
-- fixed size crops any UI needing more room.
--
-- `tile` folds them into the scroll as ordinary columns. Omarchy's center and
-- size rules stay in its defaults but go inert, since the layout owns a tiled
-- window's geometry.
--
-- Set to false and `hyprctl reload` to get Omarchy's behaviour back.
local tile_omarchy_floats = true

-- Fraction of the monitor, not pixels. 0.5 is the first entry in
-- scrolling.explicit_column_widths (looknfeel.lua), so these open at half width
-- and SUPER+O toggles straight to full.
local popup_width = 0.5

if tile_omarchy_floats then
  o.window({ tag = "floating-window" }, { tile = true, scrolling_width = popup_width })

  -- Floated by a direct class rule rather than the tag, so the rule above never
  -- reaches it. It resizes normally and fills a column.
  o.window("^omacalc$", { tile = true, scrolling_width = popup_width })

  -- Opt an app back out as you hit one, e.g.:
  -- o.window("org.gnome.NautilusPreviewer", { float = true })
  --
  -- A per-class width only applies where the tag does not, as above: a
  -- tag-matched rule wins over a class-matched one for this property whatever
  -- the file order, because tags are assigned while rules are still resolving.
end

-- Windows that arrive floating on their own are not covered by the tag, and stay
-- that way deliberately. Nothing catches them generically: there is no "is a
-- dialog" match, and `float = true` cannot drive placement, because a window
-- only satisfies that match once something has already floated it, so the rule
-- resolves after placement is settled and `tile` is dropped. Tiling one means
-- naming the app, and often a measured width with it -- a client that hard-codes
-- its geometry keeps painting that size inside the stretched frame. Where the
-- hard-coded size is also too small for the app's own content there is no fix
-- here at all: `size` and `no_max_size` are both ignored, and no min/max size is
-- exposed in the Lua API or in `hyprctl clients`.
