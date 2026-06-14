-- Launcher binding (Vicinae per Q13).
-- Vicinae runs as a daemon (vicinae.service); the CLI's `toggle` subcommand
-- raises/dismisses the launcher window. Bare `vicinae` just prints help.

o.bind("SUPER + SPACE", "Launch apps (Vicinae)", "vicinae toggle")
