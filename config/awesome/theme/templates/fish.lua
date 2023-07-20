local helpers = require("helpers")

local _fish = {}

_fish.name = "fish"

_fish.path = "fish/conf.d"
_fish.filename = "theme.fish"

_fish.gen = function(pal)
	local _pal = helpers.misc.palette_without_sharp(pal)
	local template = helpers.misc.template(
		[[
# ${name} colorscheme for Fish
# ~/.config/fish/conf.d/theme.fish

# --> special
set -l fg ${fg}
set -l sel ${bg4}

# --> palette
set -l red ${red}
set -l green ${green}
set -l yellow ${yellow}
set -l orange ${orange}
set -l blue ${blue}
set -l magenta ${magenta}
set -l pink ${pink}
set -l cyan ${cyan}
set -l gray ${gray}

# Syntax Highlighting
set -g fish_color_normal $fg
set -g fish_color_command $green
set -g fish_color_param $fg
set -g fish_color_keyword $red
set -g fish_color_quote $green
set -g fish_color_redirection $magenta
set -g fish_color_end $orange
set -g fish_color_error $red
set -g fish_color_gray $gray
set -g fish_color_selection --background=$sel
set -g fish_color_search_match --background=$sel
set -g fish_color_operator $blue
set -g fish_color_escape $magenta
set -g fish_color_autosuggestion $gray
set -g fish_color_cancel $red

# Prompt
set -g fish_color_cwd $yellow
set -g fish_color_user $cyan
set -g fish_color_host $blue

# Completion Pager
set -g fish_pager_color_progress $gray
set -g fish_pager_color_prefix $magenta
set -g fish_pager_color_completion $fg
set -g fish_pager_color_description $gray
    ]],
		_pal
	)

	return template
end

return _fish
