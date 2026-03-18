{ config, pkgs, inputs, ... }:

let
  music-assistant-companion = pkgs.callPackage ../../../pkgs/music-assistant-companion.nix {};
in {
  imports = [
      ../common/emulation.nix
  ];
  home-manager.users.${config.my.user.name}.imports = [
    inputs.plasma-manager.homeModules.plasma-manager
    ../../home-manager/roles/desktop.nix
  ];

  services.displayManager = {
    sddm.enable = true;
    autoLogin.enable = true;
    autoLogin.user = config.my.user.name;
  };

  hardware.xone.enable = true;

  programs.steam = {
    enable = true;
    extraCompatPackages = with pkgs; [ proton-ge-bin ];
    package = pkgs.steam.override {
      extraEnv = {
        MANGOHUD = "1";
        GAMEMODERUN = "1";
        PROTON_ENABLE_HDR = "1";
      };
    };
  };
  programs.gamescope.enable = true;
  programs.gamemode.enable = true;
  programs.kdeconnect.enable = true;

  services.printing.enable = true;

  services.xserver.xkb = {
    layout = "gb";
    variant = "";
  };


  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  environment.systemPackages = with pkgs; [
    gamescope-wsi # gamescope HDR won't work without this
    moonlight-qt
    jellyfin-desktop
    google-chrome
    pwvucontrol
    mesa-demos
    vulkan-tools
    v4l-utils
    music-assistant-companion
  ];

  #systemd.user.services.music-assistant-companion = {
  #  wantedBy = [
  #    "pipewire.service"
  #  ];
  #  after = [
  #    "graphical.target"
  #  ];
  #  serviceConfig = {
  #    ExecStart = "${music-assistant-companion}/bin/music-assistant-companion";
  #  };
  #};
  fonts = {
    packages = [
      pkgs.font-awesome
    ];
  };
}
