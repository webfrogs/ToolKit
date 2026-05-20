local config = require("conf/config")
local hostname = config.hostname
if hostname == "carl-x1mini-arch" then
  require("conf/monitors/x1mini")
else
  require("conf/monitors/default")
end
