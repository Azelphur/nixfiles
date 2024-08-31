{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    hyprlock
  ];
  programs.hyprlock.enable = true;
  wayland.windowManager.hyprland.settings = {
    bindd = [
      "$shiftMod, x, Launch Rofi, exec, hyprlock"
    ];
  };
  programs.hyprlock.settings = {
    general = {
      disable_loading_bar = true;
      grace = 0;
      hide_cursor = true;
      no_fade_in = false;
    };

    background = [
      {
        path = "/etc/nixos/hosts/azelphur-framework/wallpaper.png";
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
