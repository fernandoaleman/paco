-- paco autostart defaults. Loaded by default.hypr.paco at session start.

-- Status bar (iter 16)
o.exec_on_start("waybar")

-- Notification daemon (iter 16)
o.exec_on_start("mako")

-- System service tray applets (iter 19)
o.exec_on_start("nm-applet --indicator")
o.exec_on_start("blueman-applet")

-- 1Password runs in the tray for browser autofill (iter 20c).
-- --silent suppresses the main window on launch; the icon lives in
-- waybar's tray until you Ctrl+. or click the extension.
o.exec_on_start("1password --silent")

-- Future iterations will add:
--   hypridle (iter 17 area)
