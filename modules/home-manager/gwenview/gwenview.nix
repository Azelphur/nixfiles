{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    kdePackages.gwenview
  ];
  xdg = {
    mimeApps = {
      enable = true;
      defaultApplications = {
        x-terminal-emulator = "kitty.desktop";
        "image/png" = "org.kde.gwenview.desktop";
      };
    };
  };
}
