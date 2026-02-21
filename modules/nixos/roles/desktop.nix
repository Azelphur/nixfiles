{ config, pkgs, inputs, ... }:

{
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

  programs.steam.enable = true;
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
  ];

  fonts = {
    packages = [
      pkgs.font-awesome
    ];
  };
}
