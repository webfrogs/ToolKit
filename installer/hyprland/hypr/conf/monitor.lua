local config = require("conf/config")
local hostname = config.hostname
if hostname == "carl-x1mini-arch" then
  require("conf/monitors/x1mini")
elseif hostname == "carl-x1-arch" then
  require("conf/monitors/x1")
else
  require("conf/monitors/default")
end
