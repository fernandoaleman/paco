-- Shared path constants for paco's Hyprland Lua modules.
-- Lua's require() gives each module a local scope, so modules that need
-- these paths import this table instead of repeating os.getenv() lookups.

local home = os.getenv("HOME")

return {
  home = home,
  config_home = os.getenv("XDG_CONFIG_HOME") or (home .. "/.config"),
  state_home = os.getenv("XDG_STATE_HOME") or (home .. "/.local/state"),
  paco_path = os.getenv("PACO_PATH") or (home .. "/.local/share/paco"),
}
