-- Theme-managed Hyprland color overrides.
-- Loaded by ~/.config/hypr/looknfeel.lua via dofile().

hl.config({
  general = {
    col = {
      active_border = { colors = { "rgba({{ accent_strip }}ee)", "rgba({{ mauve_strip }}ee)" }, angle = 45 },
      inactive_border = "rgba({{ surface1_strip }}aa)",
    },
  },
})
