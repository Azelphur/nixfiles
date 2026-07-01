{ pkgs, ... }:

let
  elite-intel = pkgs.callPackage ../../../../pkgs/elite-intel.nix {};
  elite-dangerous = pkgs.writeShellScriptBin "elite-dangerous" ''
  #!/usr/bin/env bash
  set -euo pipefail

  steam steam://rungameid/359320
  hyprctl eval 'hl.exec_cmd("gwenview /home/azelphur/Downloads/EDRefCard_files/pwksfe-vkb-gladiator-nxt-premium-right_vfE1.jpg", {workspace = 52, no_initial_focus = true})'
  hyprctl eval 'hl.exec_cmd("elite-intel", { workspace = 53, no_initial_focus = true })'
  hyprctl eval 'hl.exec_cmd("edmarketconnector", { workspace = 54, no_initial_focus = true })'
  '';
in
{
  home.packages = with pkgs; [
    edmarketconnector
    min-ed-launcher
    elite-intel
    elite-dangerous
  ];

  xdg.desktopEntries."elite-dangerous" = {
    name = "Elite Dangerous";
    exec = "${elite-dangerous}/bin/elite-dangerous";
    icon = "steam_icon_359320";
    terminal = false;
    categories = [ "Game" ];
  };

  wayland.windowManager.hyprland = {
    extraConfig = ''
      hl.on("window.close", function(w)
        if w.class == "steam_app_359320" then
          hl.exec_cmd("pkill -f elite_intel.jar")
          hl.exec_cmd("pkill -f EDMarketConnector.py")
          hl.exec_cmd("pkill -f gwenview")
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
          workspace = 51;
          no_initial_focus = true;
        }
      ];
    };
  };
}
