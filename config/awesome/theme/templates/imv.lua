local helpers = require("helpers")

local _imv = {}

_imv.name = "imv"

_imv.path = "imv"
_imv.filename = "config"

_imv.gen = function(pal)
	local template = helpers.misc.template(
		[[
# ▪  • ▌ ▄ ·.  ▌ ▐·
# ██ ·██ ▐███▪▪█·█▌
# ▐█·▐█ ▌▐▌▐█·▐█▐█•
# ▐█▌██ ██▌▐█▌ ███ 
# ▀▀▀▀▀ █▪▀▀▀. ▀  
# Created by: Dang Minh Ngo
# Github: @dangminhngo
# Email: dangminhngo.dev@gmail.com

# ${name} colorscheme for imv
# ~/.config/imv/config

# styling
[options]
background = ${bg}
fullscreen = false
overlay = true
overlay_text_color = ${white}
overlay_background_color = ${bg2}
overlay_background_alpha = ff
overlay_font = Jetka:11
overlay_position_bottom = false

# bindings
[binds]
j = next
k = prev]],
		pal
	)

	return template
end

return _imv
