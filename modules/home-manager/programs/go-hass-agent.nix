{ config, lib, pkgs, ... }:

let
  cfg = config.programs.go-hass-agent;
  tomlFormat = pkgs.formats.toml {};
  go-hass-agent = pkgs.callPackage ../../../pkgs/go-hass-agent.nix {};
  preferencesTemplate =
    tomlFormat.generate "preferences.toml.template" cfg.preferences;

in
{
  options.programs.go-hass-agent = {
    enable = lib.mkEnableOption "go-hass-agent";

    preferences = lib.mkOption {
      type = tomlFormat.type;
      default = { };
      description = "Preferences for go-hass-agent (TOML).";
    };
    commands = lib.mkOption {
      type = tomlFormat.type;
      default = { };
      description = "Commands for go-hass-agent (TOML).";
    };
    envFile = lib.mkOption {
      type = lib.types.nullOr lib.types.path;
      default = null;
      description = "Environment file";
    };
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ 
      go-hass-agent
      pkgs.systemd-credsubst
    ];

    xdg.configFile."go-hass-agent/commands.toml".source =
      tomlFormat.generate "commands.toml" cfg.commands;

    # Systemd user service
    systemd.user.services.go-hass-agent = {
      Unit = {
        Description = "go-hass-agent";
        Wants = [ "network-online.target" ];
        After = [ "network-online.target" ];
      };

      Service = {
        #ExecStartPre = "${pkgs.systemd-credsubst}/bin/systemd-credsubst -c --input ${preferencesTemplate} --output ${config.xdg.configHome}/go-hass-agent/preferences.toml";
        ExecStart = "${go-hass-agent}/bin/go-hass-agent run";
        Restart = "always";
        RestartSec = 5;
      };

      Install = {
        WantedBy = [ "default.target" ];
      };
    };
  };
}
