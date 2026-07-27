{ pkgs, inputs, ... }:

let
  elite-intel = pkgs.callPackage ../../../../pkgs/elite-intel.nix {};
in
{
  home.packages = with pkgs; [
    edmarketconnector
    min-ed-launcher
    elite-intel
  ];

  home.activation.edmc-hotkeys = ''
    PLUGINS="$HOME/.local/share/EDMarketConnector/plugins"
    TARGET="$PLUGINS/EDMCHotkeys"
    SRC="${inputs.edmc-hotkeys}"

    mkdir -p "$PLUGINS"

    # copy instead of symlink
    if [ ! -d "$TARGET" ]; then
      cp -r "$SRC" "$TARGET"
      chmod -R u+rw "$TARGET"
    fi
  '';

  wayland.windowManager.hyprland = {
    extraConfig = ''
      hl.on("window.close", function(w)
        if w.class == "steam_app_359320" then
          windows = hl.get_windows({ tag = "elite-dangerous-companion*" })
          for _, window in pairs(windows) do
              hl.dispatch(hl.dsp.window.close({ window = "address:"..window.address }))
          end
          -- ED Market Connector seems to be special
          hl.dispatch(hl.dsp.window.close({ window = "class:Edmarketconnector" }))
        end
      end)
      hl.on("window.open", function(w)
        if w.class == "steam_app_359320" then
          hl.exec_cmd("gwenview /home/azelphur/Downloads/EDRefCard_files/pwksfe-vkb-gladiator-nxt-premium-right_vfE1.jpg", {workspace = "name:5 ➡ 2", no_initial_focus = true, tag="elite-dangerous-companion"})
          hl.exec_cmd("elite-intel", { workspace = "name:5 ➡ 3", no_initial_focus = true, tag="elite-dangerous-companion"})
          hl.exec_cmd("edmarketconnector", { workspace = "name:5 ➡ 3", no_initial_focus = true, tag="elite-dangerous-companion"})
        end
      end)
      '';
    settings = {
      window_rule = [
        {
          name = "Elite Dangerous";
          match = {
            class = "steam_app_359320";
          };
          fullscreen = true;
          workspace = "name:5 ➡ 1";
          no_initial_focus = true;
        }
      ];
    };
  };
}
