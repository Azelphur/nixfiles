{ config, pkgs, ... }:

{
  xdg.desktopEntries = {
    aircon-fuzzel = {
      name = "Clipboard url title";
      genericName = "Clipboard url title";
      exec = "${pkgs.writeScriptBin "clipboard-title.py" (builtins.readFile ./clipboard-title.py)}/bin/clipboard-title.py";
      terminal = false;
      categories = [ "Application" ];
      #icon = ./assets/heat-pump.svg;
    };
  };
  home.packages = with pkgs [
    python312Packages.pycookiecheat
  ];
  home.file = {
    ".bin/assets/aircon".source = ./assets;
  };
}
