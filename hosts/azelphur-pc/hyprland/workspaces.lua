monitors = require("monitors")
modifiers = require("modifiers")

-- If we release super, always exit submap
hl.bind(
    "SUPER + SUPER_L",
    hl.dsp.submap("reset"),
    {release = true, transparent = true, submap_universal = true}
)

for monitor_num, monitor in ipairs({ "left", "top", "bottom", "right", "simrig" }) do
    -- Generate workspace rules binding workspaces to monitors
    for workspace_num=1, 10 do
        hl.workspace_rule({
            workspace = tostring(monitor_num) .. tostring(workspace_num % 10),
            monitor = monitors[monitor],
            default = workspace_num % 10 == 1 and true or false,
        })

    end

    -- Bind super+N to activate submap
    for _, action in ipairs({"workspace", "movetoworkspace", "movetoworkspacesilent"}) do
        if action == "workspace" then
            modifier = modifiers.mainMod
            func = hl.dsp.focus
            follow = true
        elseif action == "movetoworkspace" then
            modifier = modifiers.shiftMod
            func = hl.dsp.window.move
            follow = true
        elseif action == "movetoworkspacesilent" then
            modifier = modifiers.ctrlMod
            func = hl.dsp.window.move
            follow = false
        end
        hl.bind(
             b({modifier, tostring(monitor_num)}),
             hl.dsp.submap(monitor .. "-" .. action),
             { description = monitor .. "-" ..action .. " submap" }
        )
    
        hl.define_submap(monitor .. "-" .. action, function()
            for workspace_num=1, 10 do
                real_workspace_num = tostring(((monitor_num) * 10) + workspace_num)
                hl.bind(
                    b({modifier, tostring(workspace_num % 10)}),
                    func({workspace = real_workspace_num, follow = follow}),
                    { description = monitor .. "-" .. action .. "-" .. real_workspace_num }
                )
                hl.bind(
                    b({modifier, tostring(workspace_num % 10)}),
                    hl.dsp.submap("reset")
                )
            end

            hl.bind("escape", hl.dsp.submap("reset"))
        end)
    end
end
