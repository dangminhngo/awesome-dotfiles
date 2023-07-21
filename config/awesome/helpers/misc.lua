local awful = require("awful")
local naughty = require("naughty")
local gears = require("gears")
local beautiful = require("beautiful")
local icons = require("icons")
local math = math
local os = os
local capi = { awesome = awesome, client = client }

local _misc = {}

-- Send key
function _misc.send_key(c, key)
	awful.spawn.with_shell("xdotool key --window " .. tostring(c.window) .. " " .. key)
end

--- Converts string representation of date (2020-06-02T11:25:27Z) to date
function _misc.parse_date(date_str)
	local pattern = "(%d+)%-(%d+)%-(%d+)T(%d+):(%d+):(%d+)%Z"
	local y, m, d, h, min, sec, _ = date_str:match(pattern)

	return os.time({ year = y, month = m, day = d, hour = h, min = min, sec = sec })
end

--- Converts seconds to "time ago" representation, like '1 hour ago'
function _misc.to_time_ago(seconds)
	local days = seconds / 86400
	if days >= 1 then
		days = math.floor(days)
		return days .. (days == 1 and " day" or " days") .. " ago"
	end

	local hours = (seconds % 86400) / 3600
	if hours >= 1 then
		hours = math.floor(hours)
		return hours .. (hours == 1 and " hour" or " hours") .. " ago"
	end

	local minutes = ((seconds % 86400) % 3600) / 60
	if minutes >= 1 then
		minutes = math.floor(minutes)
		return minutes .. (minutes == 1 and " minute" or " minutes") .. " ago"
	end

	return "Now"
end

function _misc.tag_back_and_forth(tag_index)
	local s = awful.screen.focused()
	local tag = s.tags[tag_index]
	if tag then
		if tag == s.selected_tag then
			awful.tag.history.restore()
		else
			tag:view_only()
		end

		local urgent_clients = function(c)
			return awful.rules.match(c, { urgent = true, first_tag = tag })
		end

		for c in awful.client.iterate(urgent_clients) do
			capi.client.focus = c
			c:raise()
		end
	end
end

function _misc.prompt(action, textbox, prompt, callback)
	if action == "run" then
		awful.prompt.run({
			prompt = prompt,
			-- prompt       = "<b>Run: </b>",
			textbox = textbox,
			font = beautiful.font_name .. "Regular 12",
			done_callback = callback,
			exe_callback = awful.spawn,
			completion_callback = awful.completion.shell,
			history_path = awful.util.get_cache_dir() .. "/history",
		})
	elseif action == "web_search" then
		awful.prompt.run({
			prompt = prompt,
			-- prompt       = '<b>Web search: </b>',
			textbox = textbox,
			font = beautiful.font_name .. "Regular 12",
			history_path = awful.util.get_cache_dir() .. "/history_web",
			done_callback = callback,
			exe_callback = function(input)
				if not input or #input == 0 then
					return
				end
				awful.spawn.with_shell("noglob " .. "xdg-open https://www.google.com/search?q=" .. "'" .. input .. "'")
				naughty.notify({
					title = "Searching the web for",
					text = input,
					icon = gears.color.recolor_image(icons.web_browser, beautiful.accent),
					urgency = "low",
				})
			end,
		})
	end
end

---Round float to nearest int
-- @param x number Float
-- @return number
function _misc.round(x)
	return x >= 0 and math.floor(x + 0.5) or math.ceil(x - 0.5)
end

---Clamp value between the min and max values.
-- @param value number
-- @param min number
-- @param max number
function _misc.clamp(value, min, max)
	return math.min(math.max(value, min), max)
end

function _misc.trim(s)
	return string.gsub(s, "^%s*(.-)%s*$", "%1")
end

function _misc.deepcopy(orig, copies)
	copies = copies or {}
	local orig_type = type(orig)
	local copy
	if orig_type == "table" then
		if copies[orig] then
			copy = copies[orig]
		else
			copy = {}
			copies[orig] = copy
			for orig_key, orig_value in next, orig, nil do
				copy[_misc.deepcopy(orig_key, copies)] = _misc.deepcopy(orig_value, copies)
			end
			setmetatable(copy, _misc.deepcopy(getmetatable(orig), copies))
		end
	else -- number, string, boolean, etc
		copy = orig
	end
	return copy
end

function _misc.template(tpl, pal)
	return (
		tpl:gsub("($%b{})", function(w)
			local k = w:sub(3, -2)
			if k == "name" then
				return pal.name or w
			end

			return pal[w:sub(3, -2)] or w
		end)
	)
end

function _misc.palette_without_sharp(pal)
	local _pal = _misc.deepcopy(pal)
	for k, v in pairs(pal) do
		if type(v) == "string" then
			_pal[k] = v:gsub("^#", "")
		end
	end
	return _pal
end

function _misc.cwd(file)
	local chr = os.tmpname():sub(1, 1)
	if chr == "/" then
		-- linux
		chr = "/[^/]*$"
	else
		-- windows
		chr = "\\[^\\]*$"
	end
	return arg[0]:sub(1, arg[0]:find(chr)) .. (file or "")
end

return _misc
