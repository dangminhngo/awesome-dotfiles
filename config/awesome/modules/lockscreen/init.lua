local gfs = require("gears.filesystem")
local lock_screen = {}

local config_dir = gfs.get_configuration_dir()
package.cpath = package.cpath .. ";" .. config_dir .. "modules/lockscreen/lib/?.so;"

lock_screen.init = function()
	require("modules.lockscreen.lockscreen")
end

lock_screen.authenticate = function(password)
	local pam = require("liblua_pam")
	local result = pam.auth_current_user(password)
	return result
end

return lock_screen
