{ config, lib, pkgs, inputs, ...}:

{
  imports = [
    ../common/docker.nix
    ../common/obs-studio.nix
    ../common/home-assistant-shutdown.nix
  ];
  home-manager.users.${config.my.user.name}.imports = [
    inputs.plasma-manager.homeModules.plasma-manager
    ../../home-manager/roles/pc.nix
  ];
  stylix.enable = true;
  stylix.base16Scheme = ../../../assets/mytheme.yaml;
  services.xserver.enable = true;
  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  environment.sessionVariables = {
    SteamAppUser = "qshadowp";
    HYPRCURSOR_THEME = "rose-pine-hyprcursor";
  };

  environment.systemPackages = with pkgs; [
    pulseaudio # dependency for XF86Volume keybinds
    spice-gtk # required for virt-manager
    borgbackup
    element-desktop
    kdePackages.dolphin
    kdePackages.kate
    kdePackages.ark
    orca-slicer
    tigervnc
    ffmpeg-full
    mpv
    vlc
    file
    libreoffice
    grimblast
    gimp
    networkmanagerapplet
    brightnessctl
    electrum
    openscad
    yt-dlp
    rpi-imager
    rose-pine-hyprcursor
  ];

  programs.virt-manager.enable = true;

  xdg.portal = {
    enable = true;
    config = {
      hyprland = {
        default = [
          "hyprland"
          "kde"
        ];
      };
    };
    configPackages = with pkgs; [
      xdg-desktop-portal-hyprland
      kdePackages.xdg-desktop-portal-kde
    ];
  };
}
