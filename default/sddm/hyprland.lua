-- Minimal Hyprland config for the SDDM Wayland greeter.
-- SDDM uses this as the compositor while it renders its own login UI.
-- Strip animations, splash, and the Hyprland logo so SDDM looks clean.

hl.config({
  misc = {
    disable_hyprland_logo = true,
    disable_splash_rendering = true,
    force_default_wallpaper = 0,
  },

  animations = {
    enabled = false,
  },
})
