{ pkgs, config, monitors, ... }:

let
  stop-pipwindow = pkgs.writeShellScriptBin "stop-pipwindow" ''
    pkill -f "electron /home/azelphur/.config/pipwindow/pipwindow.js"
  '';
  run-pipwindow = pkgs.writeShellScriptBin "run-pipwindow" ''
    setsid electron /home/azelphur/.config/pipwindow/pipwindow.js "$@" >/dev/null 2>&1 < /dev/null &
    exit 0
  '';
  toggleSimrig = import ../../../../hosts/azelphur-pc/scripts/toggle-simrig.nix {
    inherit pkgs monitors;
  };
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
          exec = "${run-pipwindow}/bin/run-pipwindow https://homeassistant.home.azelphur.com/dashboard-pipwindows/doorbell?kiosk";
        }
        {
          name = "Close PIPWindow";
          exec = "${stop-pipwindow}/bin/stop-pipwindow";
        }
        {
          name = "Switch to simrig";
          exec = "${toggleSimrig}/bin/toggle-simrig simrig";
        }
        {
          name = "Switch to desktop";
          exec = "${toggleSimrig}/bin/toggle-simrig desktop";
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
