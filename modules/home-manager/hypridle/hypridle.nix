{ config, pkgs, ... }:

{
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
      };
      listener = {
        timeout = 10;
        on-timeout = "pidof hyprlock && hyprctl dispatch dpms off;";
        on-resume = "hyprctl dispatch dpms on;";
      };
    };
  };
}
