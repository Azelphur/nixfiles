{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    hyprlock
  ];
  stylix.targets.hyprlock.enable = false;
  programs.hyprlock.enable = true;
  wayland.windowManager.hyprland.settings = {
    bindd = [
      "$shiftMod, x, Lock Session, exec, loginctl lock-session"
    ];
  };
}
