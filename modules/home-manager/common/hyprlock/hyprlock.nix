{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    hyprlock
  ];
  stylix.targets.hyprlock.enable = false;
  programs.hyprlock.enable = true;
}
