{ config, lib, pkgs, inputs, ...}:

{
  imports = [
    ../common/crunchyroll-linux.nix
  ];
  services.desktopManager.plasma6.enable = true;

  environment.etc."wallpaper.png".source = ../../../assets/htpc-background.png;
  swapDevices = [
    {
      device = "/swapfile";
      size = 32 * 1024; # 64GB
    }
  ];
  environment.sessionVariables = {
    QTWEBENGINE_FORCE_USE_GBM = 0;
  };

  programs.fcast-receiver.enable = true;

  environment.systemPackages = with pkgs; [
    vacuum-tube
    flex-launcher
    snapcast
  ];

  #systemd.user.services.snapclient = {
  #  wantedBy = [
  #    "pipewire.service"
  #  ];
  #  after = [
  #    "pipewire.service"
  #  ];
  #  serviceConfig = {
  #    ExecStart = "${pkgs.snapcast}/bin/snapclient";
  #  };
  #};

  home-manager.users.${config.my.user.name}.imports = [
    inputs.plasma-manager.homeModules.plasma-manager
    ../../home-manager/roles/htpc.nix
  ];
}
