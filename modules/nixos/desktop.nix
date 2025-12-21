{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    ./go-hass-agent.nix
  ];

  services.flatpak.enable = true;

  xdg = {
    terminal-exec = {
      enable = true;
      settings = {
        default = [ "kitty.desktop" ];
      };
    };
  };

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

  virtualisation.docker = {
    enable = true;
  };

  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };


  programs.kdeconnect.enable = true;

  programs.hyprland = {
    enable = true;
    withUWSM = true;
  };

  services.getty.autologinUser = "azelphur";

  services.xserver.enable = true;
  services.xserver.displayManager.lightdm.enable = false;

  services.gnome.gnome-keyring.enable = true;

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  stylix.base16Scheme = ./mytheme.yaml;
  stylix.enable = true;
  stylix.autoEnable = true;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
  };

  environment.systemPackages = with pkgs; [
    inputs.rose-pine-hyprcursor.packages.${pkgs.system}.default
    borgbackup
    radeontop
    nvtopPackages.amd
    freecad
    dmidecode
  ];
}
