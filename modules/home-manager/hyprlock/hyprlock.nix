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
}
