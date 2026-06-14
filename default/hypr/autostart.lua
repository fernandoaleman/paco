-- paco autostart defaults. Loaded by default.hypr.paco at session start.

-- Status bar (iter 16)
o.exec_on_start("waybar")

-- Notification daemon (iter 16)
o.exec_on_start("mako")

-- System service tray applets (iter 19)
o.exec_on_start("nm-applet --indicator")
o.exec_on_start("blueman-applet")

-- Future iterations will add:
--   hypridle (iter 17 area)
