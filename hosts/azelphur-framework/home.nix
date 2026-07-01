{ config, pkgs, inputs, lib, ... }:

{
  imports = [
    ../../modules/home-manager/roles/default.nix
  ];
  wayland.windowManager.hyprland = {
    extraConfig = ''
      -- Switch workspaces with mainMod + [0-9]
      -- Move active window to a workspace with mainMod + SHIFT + [0-9]
      for i = 1, 10 do
          local key = i % 10 -- 10 maps to key 0
          hl.bind(b({modifiers.mainMod, key}), hl.dsp.focus({ workspace = i}))
          hl.bind(b({modifiers.shiftMod, key}), hl.dsp.window.move({ workspace = i }))
      end
      hl.monitor({
        output = "eDP-1",
        mode = "2256x1504@60",
        position = "0x0",
        scale = 1,
        disabled = false,
      })
    ''; 
    settings = {
      config = {
        input = {
          kb_layout = "gb";
          kb_variant = "colemak";
        };
      };
      exec_cmd = [
        "uwsm app -- nm-applet"
      ];
    };
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
