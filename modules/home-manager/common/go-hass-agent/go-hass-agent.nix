{ pkgs, config, ... }:

let
  stop-pipwindow = pkgs.writeShellScriptBin "stop-pipwindow" ''
    pkill -f "electron /home/azelphur/.config/pipwindow/pipwindow.js"
  '';
  run-pipwindow = pkgs.writeShellScriptBin "run-pipwindow" ''
    setsid electron /home/azelphur/.config/pipwindow/pipwindow.js "$@" >/dev/null 2>&1 < /dev/null &
    exit 0
  '';
in
{
  imports = [
    ../../programs/go-hass-agent.nix
  ];
  programs.go-hass-agent = {
    enable = true;
    commands = {
      button = [
        {
          name = "Doorbell";
          exec = "run-pipwindow https://homeassistant.home.azelphur.com/dashboard-pipwindows/doorbell?kiosk";
        }
        {
          name = "Close PIPWindow";
          exec = "stop-pipwindow";
        }
      ];
    };
  };
  home.packages = [
    stop-pipwindow
    run-pipwindow
    pkgs.electron # Used for PIPView
  ];
  home.file = {
    ".config/pipwindow/pipwindow.js".source = ./pipwindow.js;
  };
}
