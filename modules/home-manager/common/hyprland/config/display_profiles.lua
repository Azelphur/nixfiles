monitors = require("monitors")

local function enable_desk()
    hl.monitor({
        output = monitors.left,
        mode = "3840x2160@60",
        position = "0x0",
        scale = 1.333333,
        transform = 1,
        disabled = false,
    })

    hl.monitor({
        output = monitors.top,
        mode = "5120x1440@240",
        position = "1620x0",
        scale = 1,
        transform = 2,
        bitdepth = 10,
        cm = "hdr",
        sdrbrightness = 1.3,
        sdrsaturation = 1.2,
        disabled = false,
    })

    hl.monitor({
        output = monitors.bottom,
        mode = "5120x1440@240",
        position = "1620x1440",
        scale = 1,
        transform = 0,
        bitdepth = 10,
        cm = "hdr",
        sdrbrightness = 1.3,
        sdrsaturation = 1.2,
        disabled = false,
    })

    hl.monitor({
        output = monitors.right,
        mode = "3840x2160@60",
        position = "6740x0",
        scale = 1.333333,
        transform = 3,
        disabled = false,
    })
end

local function disable_simrig()
    hl.monitor({
        output = monitors.simrig,
        disabled = true,
    })
end

local function enable_simrig()
    hl.monitor({
        output = monitors.simrig,
        mode = "5120x1440@240",
        position = "1620x2880",
        scale = 1,
        transform = 0,
        bitdepth = 10,
        cm = "hdr",
        sdrbrightness = 1.3,
        sdrsaturation = 1.2,
        disabled = false,
    })
end

local function disable_desk()
    for _, output in ipairs({monitors.left, monitors.right, monitors.top, monitors.bottom}) do
        hl.monitor({
            output = output,
            disabled = true
        })
    end
end

function desk()
    enable_desk()
    disable_simrig()
end

function simrig()
    enable_simrig()
    disable_desk()
end

function all()
    enable_simrig()
    enable_desk()
end

return {
    desk = desk,
    simrig = simrig,
    all = all,
}

