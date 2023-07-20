local helpers = require("helpers")

local _rofi = {}

_rofi.name = "rofi"

_rofi.path = "rofi"
_rofi.filename = "theme.rasi"

_rofi.gen = function(pal)
	local template = helpers.misc.template(
		[[
/* ${name} colorscheme for Rofi */
/* ~/.config/rofi/theme.rasi */

* {
  none:     #00000000;
  accent:   ${accent};
  dark:     ${dark};
  bg0:      ${bg0};
  bg:       ${bg};
  bg2:      ${bg2};
  bg3:      ${bg3};
  bg4:      ${bg4};
  fg0:      ${fg0};
  fg:       ${fg};
  fg2:      ${fg2};
  fg3:      ${fg3};
  black:    ${black};
  red:      ${red};
  orange:   ${orange};
  yellow:   ${yellow};
  green:    ${green};
  teal:     ${teal};
  cyan:     ${cyan};
  blue:     ${blue};
  magenta:  ${magenta};
  pink:     ${pink};
  white:    ${white};
  gray:     ${gray};
}]],
		pal
	)

	return template
end

return _rofi
