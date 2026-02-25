# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules/nixos/common/check-mk-agent/check-mk-agent.nix
  ];
  networking.hostName = "azelphur-server";

  # Enable ZFS
  boot.supportedFilesystems = [ "zfs" "fuse.mergerfs" ];
  boot.zfs.forceImportRoot = false;
  networking.hostId = "04e573d8";

  swapDevices = [
    {
      device = "/swapfile";
      size = 64 * 1024; # 64GB
    }
  ];

  # Enable check-mk agent for monitoring
  boot.zfs = {
    extraPools = [ "tank" ];
    devNodes = "/dev/disk/by-id";
  };

  # We use borgmatic, but having borg management commands is helpful
  environment.systemPackages = with pkgs; [
    pkgs.borgbackup
    pkgs.mergerfs
  ];

  # Storage user is used for bulk storage items
  users.users.storage = {
    enable = true;
    isNormalUser = false;
    isSystemUser = true;
    uid = 991;
    group = "storage";
  };
  users.groups.storage = {
    gid = 95;
  };

  # Mount Seagate Skyhawk CCTV drive
  fileSystems."/mnt/pools/cctv" = {
    fsType = "ext4";
    device = "UUID=85c04614-7425-40c5-9699-8a72a80b9e10";
    options = [
      "rw"
      "noatime"
      "data=journal"
    ];
  };

  # Mount dedicated drive for Downloads
  fileSystems."/mnt/pools/downloads" = {
    fsType = "ext4";
    device = "UUID=b7d05374-4da6-4f88-ad6f-6f053a5fb5f5";
    options = [
      "rw"
      "noatime"
    ];
  };

  # MergerFS
  fileSystems."/mnt/drives/HDD-18TB-ZR5BN1EW" = {
    fsType = "ext4";
    device = "UUID=e4cdd76c-99dd-4f48-b76b-4370639d49da";
    options = [
      "rw"
      "noatime"
    ];
  };
  fileSystems."/mnt/drives/HDD-16TB-ZL2H3HWC" = {
    fsType = "ext4";
    device = "UUID=648ebcd1-35ff-4b97-8796-b18f41a7f56b";
    options = [
      "rw"
      "noatime"
    ];
  };
  fileSystems."/mnt/drives/HDD-16TB-ZL2H46P2" = {
    fsType = "ext4";
    device = "UUID=c865d8bc-00ef-4375-9f57-202559fb102e";
    options = [
      "rw"
      "noatime"
    ];
  };
  fileSystems."/mnt/drives/HDD-16TB-ZL2H3HEH" = {
    fsType = "ext4";
    device = "UUID=02abb7bb-7719-4d0b-936c-2b2f6c02dd5a";
    options = [
      "rw"
      "noatime"
    ];
  };
  fileSystems."/mnt/pools/games" = {
    fsType = "fuse.mergerfs";
    device = "/mnt/drives/HDD-*/games";
    options = [
      "fsname=mergerfs-games"
      "cache.files=partial"
      "dropcacheonclose=true"
      "category.create=mspmfs"
      "moveonenospc=true"
      "minfreespace=10G"
      "nofail"
    ];
    depends = [
      "/mnt/drives/HDD-16TB-ZL2H3HEH"
      "/mnt/drives/HDD-16TB-ZL2H3HWC"
      "/mnt/drives/HDD-16TB-ZL2H46P2"
      "/mnt/drives/HDD-18TB-ZR5BN1EW"
    ];
  };
  fileSystems."/mnt/pools/media" = {
    fsType = "fuse.mergerfs";
    device = "/mnt/drives/HDD-*/media";
    options = [
      "fsname=mergerfs-media"
      "cache.files=partial"
      "dropcacheonclose=true"
      "category.create=mspmfs"
      "moveonenospc=true"
      "minfreespace=10G"
    ];
    depends = [
      "/mnt/drives/HDD-16TB-ZL2H3HEH"
      "/mnt/drives/HDD-16TB-ZL2H3HWC"
      "/mnt/drives/HDD-16TB-ZL2H46P2"
      "/mnt/drives/HDD-18TB-ZR5BN1EW"
    ];
  };

  # NFS
  fileSystems."/srv/nfs/games" = {
    device = "/mnt/pools/games";
    options = ["bind"];
    depends = [
      "/mnt/pools/games"
    ];
  };
  services.nfs.server.enable = true;
  services.nfs.server.exports = ''
    /srv/nfs              *(rw,fsid=root)
    /srv/nfs/games        *(ro,fsid=1)
  '';

  systemd.timers.borgmatic.timerConfig = {
      OnCalendar = "06:00";
      Persistent = true; # run missed jobs after boot
  };

  sops.defaultSopsFile = ../../secrets/azelphur-server.yaml;
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
    configurations."azelphur-server" = {
      source_directories = [
        "/home/azelphur/Docker"
        "/mnt/pools/nextcloud"
        "/mnt/pools/immich"
        "/mnt/pools/paperless"
      ];
      exclude_patterns = [
        "*.pyc"
        "*.db-wal"
        "/home/azelphur/Docker/jellyfin/config/transcoding-temp"
      ];
      repositories = [
        {
          label = "onsite";
          path = "/mnt/pools/backups/azelphur-server.borg";
        }
        {
          label = "offsite";
          path = "\${OFFSITE_REPO}/azelphur-server.borg";
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
    mode = "netserver";
    ups."azelphur-server" = {
      description = "APC SUA2200XLi in server cabinet";
      driver = "usbhid-ups";
      port = "auto";
      directives = [
        "offdelay = 120"
        "ondelay = 130"
        "lowbatt = 40"
      ];
    };
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
    upsmon.monitor."azelphur-server" = {
      system = "azelphur-server@localhost";
      powerValue = 1;
      user = "nut-admin";
      passwordFile = config.sops.secrets.nut-admin.path;
      type = "primary";
    };
  };
}
