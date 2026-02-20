{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    cliphist
    wl-clipboard
  ];
  wayland.windowManager.hyprland.settings = {
    exec-once = [
      "wl-paste --watch cliphist store"
    ];
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
