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
		launcher = scripts_dir .. "menu launcher",
		--- Default Stats
		stats = "alacritty --class btop --title btop -e btop",
	},

	--- List of binaries/shell scripts that will execute for a certain task
	utils = {
		--- Screenshot
		screenshot = scripts_dir .. "menu screenshot",
		--- Screen Capture
		screen_capture = scripts_dir .. "menu capture",
		--- Color Picker
		color_picker = scripts_dir .. "menu colorpicker",
		--- Nightlight
		nightlight = scripts_dir .. "utils nightlight",
		--- Idle Inhibitor
		idle_inhibit = scripts_dir .. "utils idle-inhibit",
		--- Exit Menu
		exit = scripts_dir .. "menu powermenu",
		--- Window Picker
		window_picker = scripts_dir .. "menu windowpicker",
		--- Turn off the screen
		screen_off = scripts_dir .. "utils lock" .. " && xset dpms force off",
	},
}
