local config = require("conf/config")

-- 按主机声明设备差异，未指定的配置使用默认值。
local defaults = { monitor = "default", xresources = "1080p" }
local devices = {
  ["carl-archlinux"] = { xresources = "4k" },
  ["carl-x1mini-arch"] = { monitor = "x1mini", xresources = "4k" },
  ["carl-x1-arch"] = { monitor = "x1", xresources = "4k" },
}
local device = devices[config.hostname] or {}

require("conf/monitors/" .. (device.monitor or defaults.monitor))

-- hiDPI support
hl.exec_cmd('xrdb "$HOME/.config/hypr/res/' .. (device.xresources or defaults.xresources) .. '.Xresources"')
