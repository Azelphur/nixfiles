{ config, pkgs, inputs, ... }:


let
  es-de = import ../../../pkgs/es-de.nix {inherit pkgs;};
  device_list = [ "azelphur-framework" "master-bedroom-mini-pc" "living-room-mini-pc" ];
in {
  home-manager.users.${config.my.user.name}.imports = [
    ../../home-manager/common/emulation/emulation.nix
  ];
  environment.systemPackages = with pkgs; [
    nfs-utils
    retroarch-full
    ryubing
    es-de
  ];

  boot.supportedFilesystems = [ "nfs" ];

  fileSystems."/srv/nfs/games" = {
    device = "10.0.1.1:/games";
    fsType = "nfs";
    options = [
      "_netdev"
      "noauto"
      "x-systemd.automount"
      "x-systemd.mount-timeout=10"
      "timeo=14"
      "x-systemd.idle-timeout=1min"
    ];
  };

  services.syncthing = {
    enable = true;
    user = "${config.my.user.name}";
    configDir = "/home/${config.my.user.name}/.config/syncthing";
    settings = {
      devices = {
        "living-room-mini-pc" = {id = "4FHUJWZ-Z5EKTKI-RT36SE2-JZA4V4O-67KXVUX-GEP2VXL-FAK4ASC-J7MIVQF"; };
        "master-bedroom-mini-pc" = {id = "TJHG4X2-GC6NSM2-AA3YOZU-F6GLTNM-HKGWGWK-HUZ6TDY-UAD7GUP-AEKA6QH"; };
        "azelphur-framework" = {id = "HJZRT5Q-4CMC4OR-XN2BFRZ-QKKD23A-YOO2FBZ-HQP7SXS-GFBPAKI-RHJ4SQI"; };
        "azelphur-pc" = {id = "OPUEPTZ-Q524I7L-IGZYNFL-Q35CYRF-RBAFL6Y-QW3DBME-QBNFSWJ-L6NRCAM"; };
      };
      folders = {
        "Ryujinx" = {
          path = "/home/${config.my.user.name}/.config/Ryujinx/";
          devices = device_list;
          versioning = {
            type = "simple";
            params.keep = "10";
          };
        };
      };
      "Retroarch-saves" = {
        path = "/home/${config.my.user.name}/.config/retroarch/saves";
        devices = device_list;
        versioning = {
          type = "simple";
          params.keep = "10";
        };
      };
      "Retroarch-states" = {
        path = "/home/${config.my.user.name}/.config/Ryujinx/bis/user/states";
        devices = device_list;
        versioning = {
          type = "simple";
          params.keep = "10";
        };
      };
    };
  };
}
