modifiers = require("modifiers")

hl.bind(
    b({"XF86Tools"}),
    hl.dsp.exec_cmd("uwsm app -- cliphist list | head -n 2 | tail -n 1 | cliphist decode | wl-copy"),
    { description = "Swap to last clipboard entry" }
) -- F13 / fn+F1

hl.bind(
    b({"XF86Launch5"}),
    hl.dsp.exec_cmd("/home/azelphur/.bin/swap-audio-sources.sh"),
    { description = "Toggle headphones / speaker" }
) -- F14 / fn+F2

hl.bind(
    b({"XF86Launch6"}),
    hl.dsp.exec_cmd("uwsm app -- hyprpicker | wl-copy"),
    { description = "Color picker" }
) -- F15 / fn+F3

-- XF86Launch7 (unused)

hl.bind(
    b({"XF86Calculator"}),
    hl.dsp.exec_cmd("uwsm app -- firefox"),
    { description = "Launch Firefox" }
) -- Circle button (far left)

hl.bind(
    b({"XF86Mail"}),
    hl.dsp.exec_cmd("uwsm app -- kitty"),
    { description = "Launch Terminal" }
) -- Triangle button (second)

hl.bind(
    b({"Help"}),
    hl.dsp.exec_cmd("uwsm app -- dolphin"),
    { description = "Launch File Browser" }
) -- Square button (third)

hl.bind(
    b({"Cancel"}),
    hl.dsp.exec_cmd("uwsm app -- grimblast copysave area"),
    { description = "Screenshot" }
) -- Cross button (last)
