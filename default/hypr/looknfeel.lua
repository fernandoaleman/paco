-- Window decoration + animation defaults.
-- Reference: https://wiki.hypr.land/Configuring/Variables/

hl.config({
  general = {
    gaps_in = 5,
    gaps_out = 10,
    border_size = 2,
    -- Border colors are loaded from the active theme below.
    resize_on_border = false,
    allow_tearing = false,
    layout = "dwindle",
  },

  decoration = {
    rounding = 0,
    shadow = {
      enabled = true,
      range = 2,
      render_power = 3,
      color = "rgba(1a1a1aee)",
    },
    blur = {
      enabled = true,
      size = 2,
      passes = 2,
      brightness = 0.60,
      contrast = 0.75,
    },
  },

  animations = {
    enabled = true,
  },

  dwindle = {
    preserve_split = true,
    force_split = 2,
  },

  master = {
    new_status = "master",
  },
})

-- Theme-managed colors. `paco theme-set` renders
-- ~/.config/paco/current/theme/hyprland.lua from the template; this
-- dofile() applies the per-theme color overrides on top of the above.
do
  local theme_lua = os.getenv("HOME") .. "/.config/paco/current/theme/hyprland.lua"
  local f = io.open(theme_lua, "r")
  if f then
    f:close()
    dofile(theme_lua)
  end
end
