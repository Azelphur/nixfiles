# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, ... }:


{
  imports = [ 
    ./hardware-configuration.nix
    ../../modules/nixos/hardware/amd.nix
    ../../modules/nixos/hardware/keychron.nix
    ../../modules/nixos/hardware/flydigi-vader5.nix
    ../../modules/nixos/common/games-on-whales.nix
  ];

  networking.hostName = "azelphur-pc"; # Define your hostname.
  home-manager.users.${config.my.user.name}.imports = [
    ./home.nix
  ];

  # Enable support for cross compilation for raspberry pi
  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  nix.settings = {
   extra-platforms = [ "aarch64-linux" ];
  };

  sops.defaultSopsFile = ../../secrets/azelphur-pc.yaml;
  sops.secrets = {
    borg-passphrase = {};
    borgmatic-healthcheck-url = {};
    offsite-repo = {};
    nut-admin = {};
  };
  sops.templates."borgmatic-env" = {
    content = ''
      HEALTHCHECK_URL=${config.sops.placeholder.borgmatic-healthcheck-url}
      OFFSITE_REPO=${config.sops.placeholder.offsite-repo}
    '';
  };

  systemd.services.borgmatic.serviceConfig.EnvironmentFile = config.sops.templates."borgmatic-env".path;

  services.borgmatic = {
    enable = true;
    configurations."azelphur-pc" = {
      source_directories = [ "/home/${config.my.user.name}" ];
      exclude_patterns = [
        "*.pyc"
        "/home/*/.cache"
        "/home/*/.config/discord"
        "/home/*/.config/Slack"
        "/home/*/.steam-shared"
        "/home/*/Steam"
        "/home/*/.steam"
        "/home/*/.local/share/Steam"
        "/home/*/Downloads"
        "/home/*/.bitcoin/blocks"
        "/home/*/.thumbnails"
        "/home/*/Nextcloud" # Already backed up
      ];
      repositories = [
        {
          label = "onsite";
          path = "ssh://azelphur@azelphur-server/mnt/pools/backups/azelphur-pc.borg";
        }
        {
          label = "offsite";
          path = "\${OFFSITE_REPO}/azelphur-pc.borg";
        }
      ];
      encryption_passcommand = "cat ${config.sops.secrets.borg-passphrase.path}";
      keep_hourly = 4;

      keep_daily = 7;
      keep_weekly = 4;
      keep_monthly = 6;
      keep_yearly = 2;
      checks = [
        {
          name = "repository";
          # These checks were taking days and burning all I/O time
          max_duration = 1800;
        }
        {
          name = "archives";
          frequency = "2 weeks";
        }
      ];
      healthchecks = {
        ping_url = "\${HEALTHCHECK_URL}";
        send_logs = true;
      };
    };
  };

  power.ups = {
    enable = true;
    mode = "standalone";
    ups."azelphur-pc" = {
      description = "APC SUA2200i in Alfies room";
      driver = "snmp-ups";
      port = "10.0.1.13";
      directives = [
        "community = public"
        "mibs = apcc"
        "snmp_version = v1"
        "pollfreq = 15"
      ];
    };
    users."nut-admin" = {
      # A file that contains just the password.
      passwordFile = config.sops.secrets.nut-admin.path;
      upsmon = "primary";
    };
    upsmon.monitor."azelphur-pc" = {
      system = "azelphur-pc@localhost";
      powerValue = 1;
      user = "nut-admin";
      passwordFile = config.sops.secrets.nut-admin.path;
      type = "primary";
    };
  };

}

