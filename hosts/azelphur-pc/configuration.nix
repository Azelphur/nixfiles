# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, ... }:


let 
  flydigi-vader5 = pkgs.callPackage ../../pkgs/flydigi-vader5/flydigi-vader5.nix {};
in
{
  imports = [ 
    ./hardware-configuration.nix
    ../../modules/nixos/hardware/amd.nix
    ../../modules/nixos/hardware/keychron.nix
    ../../modules/nixos/common/games-on-whales.nix
  ];
  environment.systemPackages = [
    flydigi-vader5
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

  age.secrets = {
    "borg-passphrase" = {
      file = ../../secrets/borg-passphrase.age;
    };
    "azelphur-pc-health-check-url" = {
      file = ../../secrets/azelphur-pc-health-check-url.age;
    };
  };

  systemd.services.borgmatic.serviceConfig.EnvironmentFile = config.age.secrets.azelphur-pc-health-check-url.path;

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
          path = "ssh://azelphur@azelphur-backup/home/azelphur/azelphur-pc.borg";
        }
      ];
      encryption_passcommand = "cat ${config.age.secrets.borg-passphrase.path}";
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

  age.secrets = {
    "nut-admin" = {
      file = ../../secrets/nut-admin.age;
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
      passwordFile = config.age.secrets.nut-admin.path;
      upsmon = "primary";
    };
    upsmon.monitor."azelphur-pc" = {
      system = "azelphur-pc@localhost";
      powerValue = 1;
      user = "nut-admin";
      passwordFile = config.age.secrets.nut-admin.path;
      type = "primary";
    };
  };

}

