{ config, lib, pkgs, inputs, ...}:

{
  imports = [
    inputs.home-manager.nixosModules.default
    ./desktop.nix
    ./go-hass-agent.nix
  ];
  # Fixes /bin/bash and such like not existing
  services.envfs.enable = true;

  # Firmware updates
  services.fwupd.enable = true;

  services.printing.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };

  nix.settings.experimental-features = ["nix-command" "flakes" ];

  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/etc/secureboot";
  };
  boot.supportedFilesystems = [ "ntfs" ];

  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
  };
  nix.gc = {
    automatic = true;
    randomizedDelaySec = "14m";
    options = "--delete-older-than 10d";
  };

  programs.git = {
    enable = true;
    config = {
      user.name = "azelphur";
      user.email = "azelphur@azelphur.com";
      init.defaultBranch = "main";
      safe.directory = "/etc/nixos";
    };
  };

  programs.zsh.enable = true;

  boot.initrd.systemd.enable = true;
  environment.sessionVariables = {
    EDITOR = "nvim";
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = false;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.efi.canTouchEfiVariables = true;

  time.timeZone = "Europe/London";

  i18n.defaultLocale = "en_GB.UTF-8";

  console = {
    font = "Lat2-Terminus16";
    keyMap = "colemak";
  };

  fonts = {
    packages = [
      pkgs.font-awesome
    ];
  };

  users.users.azelphur = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "adbusers" "networkmanager" "dialout"];
    shell = pkgs.zsh;
  };

  environment.systemPackages = with pkgs; [
    sbctl
    vim
    git
    wget
    killall
    screen
    pciutils
    usbutils
    ethtool
    (python3.withPackages(ps: with ps; [ 
      requests
      virtualenv
    ]))
  ];

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;
}

