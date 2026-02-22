{ pkgs, config, ... }:

let
  stop-pipwindow = pkgs.writeShellScriptBin "stop-pipwindow" ''
    hyprctl --instance 0 dispatch closewindow title:PIPWindow
  '';
  run-pipwindow = pkgs.writeShellScriptBin "run-pipwindow" ''
    setsid electron /home/azelphur/.config/pipview/pipview.js "$@" >/dev/null 2>&1 < /dev/null &
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
          exec = "run-pipwindow https://homeassistant.home.azelphur.com/lovelace/doorbell-pipview";
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
    ".config/pipview/pipview.js".source = ./pipview.js;
  };
}
