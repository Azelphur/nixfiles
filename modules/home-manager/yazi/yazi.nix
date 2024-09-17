{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    yazi
  ];
  xdg.mimeApps.defaultApplications = {
    "application/zip" = ["yazi.desktop"];
  };
}
