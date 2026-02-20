{ config, pkgs, inputs, lib, ... }:

{
  imports = [
    ../../modules/home-manager/roles/default.nix
  ];
  wayland.windowManager.hyprland.settings = {
    exec-once = [
      "uwsm app -- nm-applet"
    ];
    input = {
      kb_layout = "gb";
      kb_variant = "colemak";
    };
    bindd = [] ++ (
      # workspaces
      # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
      builtins.concatLists (builtins.genList (
          x: let
            ws = let
              c = (x + 1) / 10;
            in
              builtins.toString (x + 1 - (c * 10));
          in [
            "$mainMod, ${ws}, Switch to workspace ${ws}, workspace, ${toString (x + 1)}"
            "$shiftMod, ${ws}, Move active window to workspace ${ws}, movetoworkspacesilent, ${toString (x + 1)}"
          ]
        )
        10)
    );
    monitor = ", preferred, auto, 1";
  };

  services.hyprpaper = {
    enable = true;
    settings = {
      splash = false;
      wallpaper = [
        {
          monitor = "eDP-1";
          path = "/home/azelphur/.wallpaper.png";
        }
      ];
    };
  };

  programs.hyprlock.settings = lib.mkForce {
    general = {
      disable_loading_bar = true;
      grace = 0;
      hide_cursor = true;
      no_fade_in = false;
    };

    background = [
      {
        path = "/home/azelphur/.wallpaper.png";
        blur_passes = 3;
        blur_size = 8;
      }
    ];

    input-field = [
      {
        size = "200, 50";
        position = "0, 0";
        monitor = "";
        dots_center = true;
        fade_on_empty = false;
        font_color = "rgb(202, 211, 245)";
        inner_color = "rgb(91, 96, 120)";
        outer_color = "rgb(24, 25, 38)";
        outline_thickness = 5;
        shadow_passes = 2;
      }
    ];
  };
}
