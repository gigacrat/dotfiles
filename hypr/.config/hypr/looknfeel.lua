-- Personal look'n'feel overrides, loaded after Omarchy's defaults.
-- Commented examples of other options: /usr/share/omarchy/config/hypr/looknfeel.lua

-- https://wiki.hypr.land/configuring/core/config-options/#general
hl.config({
  general = {
    -- Change to niri-like side-scrolling layout.
    layout = "scrolling",
  },
})

-- https://wiki.hypr.land/configuring/core/config-options/#decoration
hl.config({
  decoration = {
    -- Use round window corners.
    rounding = 8,
  },
})

-- https://wiki.hypr.land/configuring/layouts/scrolling-layout/
hl.config({
  scrolling = {
    -- See only one column per screen instead of two.
    column_width = 1.0,

    -- Widths toggled by SUPER+O (colresize): half screen <-> full screen.
    explicit_column_widths = "0.5, 1.0",
  },
})
