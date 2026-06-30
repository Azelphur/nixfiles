modifiers = require("modifiers")

for _, dir in ipairs({"left", "right", "up", "down"}) do
    hl.bind(
        b({modifiers.shiftMod, dir}),
        hl.dsp.window.move({ direction = dir}),
        { description = "Move window " .. dir }
    )
end

hl.bind(
    b({modifiers.shiftMod, "x"}),
    hl.dsp.exec_cmd("loginctl lock-session"),
    { description = "Lock Session" }
)

hl.bind(
    b({modifiers.mainMod, "Return"}),
    hl.dsp.exec_cmd("uwsm app -- kitty"),
    { description = "Launch terminal emulator" }
)

hl.bind(
    b({modifiers.mainMod, "Space"}),
    hl.dsp.exec_cmd("uwsm app -- fuzzel"),
    { description = "Launch Fuzzel" } 
)

hl.bind(
    b({modifiers.mainMod, "D"}),
    hl.dsp.exec_cmd("uwsm app -- dolphin"),
    { description = "Launch Dolphin" }
)

hl.bind(
    b({modifiers.shiftMod, "Q"}),
    hl.dsp.window.close(),
    { description = "Close" }
)

hl.bind(
    b({modifiers.mainMod, "mouse:272"}),
    hl.dsp.window.drag(),
    { mouse = true, description = "Move window with mouse" }
)

hl.bind(
    b({modifiers.mainMod, "mouse:273"}),
    hl.dsp.window.resize(),
    { mouse = true, description = "Resize window with mouse" }
)

hl.bind(
    b({modifiers.mainMod, "F"}),
    hl.dsp.window.fullscreen(),
    { description = "Toggle fullscreen" }
)

hl.bind(
    b({modifiers.shiftMod, "Space"}),
    hl.dsp.window.float(),
    { description = "Toggle floating" }
)


hl.bind(
    "XF86AudioRaiseVolume",
    hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ +5%"),
    { description = "Raise Volume" }
)

hl.bind(
    "XF86AudioLowerVolume",
    hl.dsp.exec_cmd("pactl set-sink-volume @DEFAULT_SINK@ -5%"),
    { description = "Lower Volume" }
)

hl.bind(
    "XF86AudioMute",
    hl.dsp.exec_cmd("pactl set-sink-mute @DEFAULT_SINK@ toggle"),
    { description = "Mute Volume" }
)

hl.bind(
    "XF86MonBrightnessUp",
    hl.dsp.exec_cmd("brightnessctl s +5%"),
    { description = "Brightness Up" }
)

hl.bind(
    "XF86MonBrightnessDown",
    hl.dsp.exec_cmd("brightnessctl s 5%-"),
    { description = "Brightness Down" }
)

hl.bind(
    "XF86AudioPlay",
    hl.dsp.exec_cmd("playerctl play-pause"),
    { description = "Media Play" }
)

hl.bind(
    "XF86AudioNext",
    hl.dsp.exec_cmd("playerctl next"),
    { description = "Media Next" }
)

hl.bind(
    "XF86AudioPrev",
    hl.dsp.exec_cmd("playerctl previous"),
    { description = "Media Previous" }
)

hl.bind(
    b({modifiers.mainMod, "F5"}),
    hl.dsp.exec_cmd("playerctl --player=spotify play-pause"),
    { description = "Spotify Media Play" }
)

hl.bind(
    b({modifiers.mainMod, "F8"}),
    hl.dsp.exec_cmd("playerctl --player=spotify next"),
    { description = "Spotify Media Next" }
)

hl.bind(
    b({modifiers.mainMod, "F7"}),
    hl.dsp.exec_cmd("playerctl --player=spotify previous"),
    { description = "Spotify Media Previous" }
)

--- https://github.com/hyprwm/Hyprland/discussions/14330#discussioncomment-16921554

Monitor_zoom = {}
function Adjust_zoom(operation)
	local monitor = hl.get_active_monitor().name
	local current = Monitor_zoom[monitor] or hl.get_config("cursor.zoom_factor")
	local new_zoom
	if operation == "*" then
		new_zoom = current * 1.1
	elseif operation == "/" then
		new_zoom = current / 1.1
		if new_zoom < 1.0 then
			new_zoom = 1.0
		end
	else
		new_zoom = 1.0
	end
	Monitor_zoom[monitor] = new_zoom
	hl.config({ cursor = { zoom_factor = new_zoom } })
end

hl.bind(modifiers.mainMod .. " + mouse_down", function()
	Adjust_zoom("*")
end)
hl.bind(modifiers.mainMod .. " + mouse_up", function()
	Adjust_zoom("/")
end)
hl.bind(modifiers.mainMod .. " + SHIFT + mouse_up", function()
	Adjust_zoom("1")
end)
hl.bind(modifiers.mainMod .. " + equal", function()
	Adjust_zoom("*")
end, { repeating = true, description = "Zoom in" })
hl.bind(modifiers.mainMod .. " + minus", function()
	Adjust_zoom("/")
end, { repeating = true, description = "Zoom out" })
hl.bind(modifiers.mainMod .. " + SHIFT + minus", function()
	Adjust_zoom("1")
end)
hl.bind(modifiers.mainMod .. " + KP_ADD", function()
	Adjust_zoom("*")
end, { repeating = true })
hl.bind(modifiers.mainMod .. " + KP_SUBTRACT", function()
	Adjust_zoom("/")
end, { repeating = true })
hl.bind(modifiers.mainMod .. " + SHIFT + KP_SUBTRACT", function()
	Adjust_zoom("1")
end)
hl.bind("MOD5 + KP_ADD", function()
	Adjust_zoom("*")
end, { repeating = true })
hl.bind("MOD5 + KP_SUBTRACT", function()
	Adjust_zoom("/")
end, { repeating = true })
hl.bind("MOD5 + SHIFT + KP_SUBTRACT", function()
	Adjust_zoom("1")
end)


