-- paco's Hyprland defaults dispatcher. Loaded by ~/.config/hypr/hyprland.lua.

require("default.hypr.helpers")

require("default.hypr.envs")
require("default.hypr.looknfeel")
require("default.hypr.input")
require("default.hypr.windows")

require("default.hypr.bindings.tiling")
require("default.hypr.bindings.terminal")
require("default.hypr.bindings.exit")
require("default.hypr.bindings.launcher")
require("default.hypr.bindings.file-manager")

require("default.hypr.autostart")

-- Future iterations will add:
--   require("default.hypr.bindings.media")       (iter 19 — swayosd)
--   require("default.hypr.bindings.webapps")     (iter 20 — webapps)
--   require("default.hypr.bindings.theme")       (iter 17 — theme system)
