{ config, pkgs, ... }:

{
  services.cliphist = {
    enable = true;
  };
  xdg.desktopEntries = {
    cliphist-fuzzel = {
      name = "Cliphist";
      genericName = "Cliphist";
      exec = "${pkgs.writeScriptBin "cliphist-fuzzel.sh" (builtins.readFile ./cliphist-fuzzel.sh)}/bin/cliphist-fuzzel.sh";
      terminal = false;
      categories = [ "Application" ];
      icon = ./clipboard.svg;
    };
  };
}
