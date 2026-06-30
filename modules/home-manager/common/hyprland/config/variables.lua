colors = require("colors")

hl.config({
    general = {
        gaps_in = 5,
        gaps_out = 10,
        border_size = 2,
        col = {
            active_border = "rgb(" .. colors.base0D .. ")",
            inactive_border = "rgb(" .. colors.base03 .. ")",
        };
    },
    xwayland = {
        force_zero_scaling = true,
        enabled = true
    },
    misc = {
        disable_hyprland_logo = true,
        disable_splash_rendering = true,
        force_default_wallpaper = 0,
    },
    input = {
        follow_mouse = 1,
        touchpad = {
            natural_scroll = false,
            disable_while_typing = false,
            tap_to_click = false,
        }
    },
    binds = {
        scroll_event_delay = 0
    },
    decoration = {
        rounding = 10,
        blur = {
            enabled = true,
            size = 3,
            passes = 1,
        },
        shadow = {
            enabled = true,
            range = 4,
            render_power = 3,
            color = "rgba(" .. colors.base00 .. "99)",
        },
    },
    input = {
        kb_layout = "gb"
    }
})
