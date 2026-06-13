-- Window decoration + animation defaults.
-- Reference: https://wiki.hypr.land/Configuring/Variables/

hl.config({
  general = {
    gaps_in = 5,
    gaps_out = 10,
    border_size = 2,

    col = {
      active_border = { colors = { "rgba(33ccffee)", "rgba(00ff99ee)" }, angle = 45 },
      inactive_border = "rgba(595959aa)",
    },

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
    bezier = { "easeOutQuint, 0.23, 1, 0.32, 1" },
    animation = {
      "windows, 1, 4, easeOutQuint",
      "windowsOut, 1, 4, easeOutQuint, popin 80%",
      "border, 1, 5, default",
      "fade, 1, 4, default",
      "workspaces, 1, 4, easeOutQuint, slide",
    },
  },

  dwindle = {
    pseudotile = true,
    preserve_split = true,
  },

  master = {
    new_status = "master",
  },

  gestures = {
    workspace_swipe = false,
  },
})
