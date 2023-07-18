local gfs = require("gears.filesystem")
local config_dir = gfs.get_configuration_dir()
local scripts_dir = config_dir .. "scripts/"

return {
	--- Default Applications
	default = {
		--- Default terminal emulator
		terminal = "alacritty",
		--- Default float terminal
		float_terminal = "alacritty --class floatterm --title floatterm",
		--- Default text editor
		text_editor = "alacritty -e nvim",
		--- Default calculator
		calculator = "alacritty --class calculator --title calculator -e calc",
		--- Default code editor
		code_editor = "code",
		--- Default web browsers
		web_browser = "firefox-developer-edition",
		second_web_browser = "chromium",
		-- Default sound control
		sound_control = "pavucontrol",
		--- Default file manager
		file_manager = "alacritty -e lf",
		--- Default network manager
		network_manager = "alacritty -e nmtui",
		--- Default bluetooth manager
		bluetooth_manager = "blueman-manager",
		--- Default power manager
		power_manager = "xfce4-power-manager",
		--- Default rofi global menu
		app_launcher = "~/.dotfiles/scripts/menus launcher",
	},

	--- List of binaries/shell scripts that will execute for a certain task
	utils = {
		--- Fullscreen screenshot
		full_screenshot = scripts_dir .. "screensht full",
		--- Area screenshot
		area_screenshot = scripts_dir .. "screensht area",
		--- Color Picker
		color_picker = scripts_dir .. "menu colorpicker",
	},
}
