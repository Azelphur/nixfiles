{ config, pkgs, ... }:

{
  systemd.user.services.kdeconnect.Service = {
    RestartSec = "2s";
  };
  services.kdeconnect = {
    enable = true;
    package = pkgs.kdePackages.kdeconnect-kde;
  };
}
