-- Learn how to configure Hyprland: https://wiki.hypr.land/Configuring/Start/

-- Make Lua's require() find:
--   - your overrides in ~/.config/  (this dir)
--   - paco's defaults in $PACO_PATH (= ~/.local/share/paco)
package.path = os.getenv("HOME")
  .. "/.config/?.lua;"
  .. (os.getenv("PACO_PATH") or (os.getenv("HOME") .. "/.local/share/paco"))
  .. "/?.lua;"
  .. package.path

-- Load all paco defaults
require("default.hypr.paco")

-- Your personal overrides. Edit these files (not the defaults).
require("hypr.monitors")
require("hypr.input")
require("hypr.bindings")
require("hypr.looknfeel")
require("hypr.autostart")
