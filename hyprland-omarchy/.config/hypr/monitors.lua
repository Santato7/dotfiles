-- See https://wiki.hypr.land/Configuring/Basics/Monitors/
-- List current monitors and supported resolutions with: hyprctl monitors all

-- Optimized for retina-class 2x displays, like 13" 2.8K, 27" 5K, 32" 6K.
hl.env("GDK_SCALE", "1")

hl.monitor({ output = "DP-3", mode = "1920x1080@143.98", position = "0x0", scale = 1 })
hl.monitor({ output = "HDMI-A-1", mode = "1366x768@59.79", position = "1920x0", scale = 1 })

for workspace = 1, 5 do
  hl.workspace_rule({ workspace = tostring(workspace), monitor = "DP-3", default = true })
end

for workspace = 6, 10 do
  hl.workspace_rule({ workspace = tostring(workspace), monitor = "HDMI-A-1", default = true })
end
