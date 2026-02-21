{ pkgs, config, ... }:

let
  go-hass-agent = pkgs.callPackage ../../../../pkgs/go-hass-agent.nix {};
  stop-pipwindow = pkgs.writeShellScriptBin "stop-pipwindow" ''
    hyprctl --instance 0 dispatch closewindow title:PIPWindow
  '';
  run-pipwindow = pkgs.writeShellScriptBin "run-pipwindow" ''
    setsid electron /home/azelphur/.config/pipview/pipview.js "$@" >/dev/null 2>&1 < /dev/null &
    exit 0
  '';
in
{
  systemd.user.services.go-hass-agent = {
    Unit = {
      description = "go-hass-agent";
      wantedBy = [ "default.target" ];
    };
    Service = {
      ExecStart = "${go-hass-agent}/bin/go-hass-agent run";
      Restart = "always";
    };
  };
  home.packages = [
    go-hass-agent
    stop-pipwindow
    run-pipwindow
    pkgs.electron # Used for PIPView
  ];
  home.file = {
    ".config/pipview/pipview.js".source = ./pipview.js;
  };
}
