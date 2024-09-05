{ config, pkgs, ... }:

{
  imports = [
    ./aircon/aircon.nix
    ./heroku-review-apps/heroku-review-apps.nix
  ];
  home.file = {
    ".bin/approval".source = ./approval/approval.py;
    ".local/share/applications/approval.desktop".source = ./approval/approval.desktop;
  };
}
