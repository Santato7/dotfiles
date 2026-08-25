-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- List current monitors and supported resolutions with: hyprctl monitors all

-- Laptop panel (13", 1920x1080). No second monitor here -- see the main
-- branch for the desktop's DP-3 + HDMI-A-1 dual-monitor setup.
hl.env("GDK_SCALE", "2")
hl.monitor({ output = "eDP-1", mode = "preferred", position = "auto", scale = 1.6 })

-- Keep all 10 workspaces around even when empty, so the bar's workspace
-- indicator shows 1-0 instead of just 1-5 (the widget only shows a
-- workspace above 5 once it actually exists).
for workspace = 1, 10 do
  hl.workspace_rule({ workspace = tostring(workspace), persistent = true })
end

hl.workspace_rule({ workspace = "r[1-10]", gaps_out = 6, gaps_in = 1 })
hl.workspace_rule({ workspace = "w[tv1]", gaps_out = 0, gaps_in = 0 })
hl.workspace_rule({ workspace = "f[1]", gaps_out = 0, gaps_in = 0 })

o.window({ float = false, workspace = "w[tv1]" }, { border_size = 0, rounding = 0 })
o.window({ float = false, workspace = "f[1]" }, { border_size = 0, rounding = 0 })

o.window({ class = "discord" }, { workspace = "9" })
o.window({ class = "Spotify", title = "Spotify Premium" }, { opacity = "0.7 override" })
o.window({ class = "Spotify" }, { workspace = "10" })
