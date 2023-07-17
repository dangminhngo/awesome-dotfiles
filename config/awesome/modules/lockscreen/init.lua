local lock_screen = {}

lock_screen.init = function()
	require("modules.lockscreen.lockscreen")
end

lock_screen.authenticate = function(password)
	local pam = require("liblua_pam")
	local result = pam.auth_current_user(password)
	return result
end

return lock_screen
