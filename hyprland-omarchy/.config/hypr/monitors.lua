-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- List current monitors and supported resolutions with: hyprctl monitors all

-- Laptop panel (13", 1920x1080). No second monitor here -- see the main
-- branch for the desktop's DP-3 + HDMI-A-1 dual-monitor setup.
hl.env("GDK_SCALE", "1")
hl.monitor({ output = "eDP-1", mode = "preferred", position = "auto", scale = 1.25 })
