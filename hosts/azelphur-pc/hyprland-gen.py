monitors = ["HDMI-A-2", "DP-5", "DP-4", "DP-6"]

def calc_ws_number(monitor_number, i):
    ws_number = ((monitor_number+1)*10)+i+1
    if i == 9:
        ws_number -= 10
    return ws_number

for monitor_number, monitor in enumerate(monitors):
    print(f"# Begin monitor {monitor}")
    for i in range(0, 10):
        workspace_number = calc_ws_number(monitor_number, i)
        s = f"workspace = {workspace_number}, monitor:{monitor}"
        if i == 0:
            s += ", default:true"
        print(s)

    for mapping in [["$mainMod", "workspace"], ["$ctrlMod", "movetoworkspace"], ["$shiftMod", "movetoworkspacesilent"]]:
        mod, dispatcher = mapping
        print(f"bind = {mod}, {monitor_number+1}, submap, {monitor}-{dispatcher}")
        print(f"submap = {monitor}-{dispatcher}")
        print(f"bindrt = {mod}, SUPER_L, submap, reset")
        for i in range(0, 10):
            workspace_number = calc_ws_number(monitor_number, i)
            key = workspace_number % 10
            print(f"bind = {mod}, {key}, {dispatcher}, {workspace_number}")
            print(f"bind = {mod}, {key}, submap, reset")
        print("bind= , escape, submap, reset")
        print("submap = reset\n")
    print(f"# End monitor {monitor}\n")
