-- Monitor configuration.
-- List current monitors and possible modes: hyprctl monitors all
-- Reference: https://wiki.hypr.land/Configuring/Basics/Monitors/

-- Auto-detect any connected monitor, preferred mode, scale 1.
hl.monitor({ output = "", mode = "preferred", position = "auto", scale = 1 })

-- Examples for additional monitors (uncomment + edit to use):
-- hl.monitor({ output = "DP-1", mode = "preferred", position = "auto", scale = 1 })
-- hl.monitor({ output = "DP-2", mode = "preferred", position = "auto", scale = 1, transform = 1 })
