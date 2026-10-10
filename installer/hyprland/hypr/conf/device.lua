local config = require("conf/config")

-- 按主机设置设备差异，其他主机使用默认配置。
local monitor
local xresources
if config.hostname == "carl-archlinux" then
  monitor = "default"
  xresources = "4k"
elseif config.hostname == "carl-x1mini-arch" then
  monitor = "x1mini"
  xresources = "4k"
elseif config.hostname == "carl-x1-arch" then
  monitor = "x1"
  xresources = "4k"
  -- hl.env("QT_SCALE_FACTOR", "2")
else
  monitor = "default"
  xresources = "1080p"
end

require("conf/monitors/" .. monitor)

-- hiDPI support
hl.exec_cmd('xrdb "$HOME/.config/hypr/res/' .. xresources .. '.Xresources"')
