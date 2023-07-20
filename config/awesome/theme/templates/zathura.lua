local helpers = require("helpers")

local _zathura = {}

_zathura.name = "zathura"

_zathura.path = "zathura"
_zathura.filename = "theme"

_zathura.gen = function(pal)
	local template = helpers.misc.template(
		[[# ${name} colorscheme for zathura
set default-fg "${fg}"
set default-bg "${bg}"

set completion-bg "${bg}"
set completion-fg "${fg}"
set completion-highlight-bg "${bg4}"
set completion-highlight-fg "${fg}"
set completion-group-bg "${bg}"
set completion-group-fg "${accent}"

set statusbar-fg "${fg}"
set statusbar-bg "${bg}"

set notification-bg "${bg}"
set notification-fg "${fg}"
set notification-error-bg "${bg}"
set notification-error-fg "${red}"
set notification-warning-bg "${bg}"
set notification-warning-fg "${yellow}"

set inputbar-fg "${fg}"
set inputbar-bg "${bg}"

set recolor-lightcolor "${bg}"
set recolor-darkcolor "${fg}"

set index-fg "${fg}"
set index-bg "${bg2}"
set index-active-fg "${fg}"
set index-active-bg "${bg}"

set render-loading-bg "${bg}"
set render-loading-fg "${fg}"

set highlight-color "${bg4}"
set highlight-fg "${accent}"
set highlight-active-color "${accent}"]],
		pal
	)

	return template
end

return _zathura
