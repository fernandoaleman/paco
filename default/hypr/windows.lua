-- Window rules. Defaults are intentionally minimal; user-facing
-- ~/.config/hypr/looknfeel.lua and bindings.lua can override.

-- Open Wayland clients on the focused workspace by default
hl.window_rule({ rule = "suppressevent maximize", match = "class:.*" })

-- Float common dialog/portal windows
hl.window_rule({ rule = "float", match = "title:Open File" })
hl.window_rule({ rule = "float", match = "title:Save File" })
hl.window_rule({ rule = "float", match = "title:Choose Files" })
