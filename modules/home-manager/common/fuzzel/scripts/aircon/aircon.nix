{ config, pkgs, ... }:

{
  xdg.desktopEntries = {
    aircon-fuzzel = {
      name = "Aircon";
      genericName = "Aircon";
      exec = "${pkgs.writeScriptBin "aircon-fuzzel.py" (builtins.readFile ./aircon-fuzzel.py)}/bin/aircon-fuzzel.py";
      terminal = false;
      categories = [ "Application" ];
      icon = ./assets/heat-pump.svg;
    };
  };
  home.file = {
    ".bin/assets/aircon".source = ./assets;
  };
}
