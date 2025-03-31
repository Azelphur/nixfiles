{ config, lib, pkgs, inputs, ...}:

{
  imports = [
    inputs.home-manager.nixosModules.default
  ];
  services.fwupd.enable = true;
  hardware.graphics = {
    enable32Bit = true;
    #package = pkgs-unstable.mesa.drivers;
    # if you also want 32-bit support (e.g for Steam)
    #driSupport32Bit = true;
    #package32 = pkgs-unstable.pkgsi686Linux.mesa.drivers;
  };
  services.printing.enable = true;
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
  xdg = {
    terminal-exec = {
      enable = true;
      settings = {
        default = [ "kitty.desktop" ];
      };
    };
  };
  programs.steam.enable = true;
  programs.kdeconnect.enable = true;
  nix.settings.experimental-features = ["nix-command" "flakes" ];
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/etc/secureboot";
  };
  boot.supportedFilesystems = [ "ntfs" ];
  nixpkgs.config.allowUnfree = true;
  programs.hyprland = {
    enable = true;
    #package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    # make sure to also set the portal package, so that they are in sync
    #portalPackage = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };
  nix.settings = {
    substituters = ["https://hyprland.cachix.org"];
    trusted-public-keys = ["hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="];
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
  services.getty.autologinUser = "azelphur";
  boot.initrd.systemd.enable = true;
  services.greetd = {
    enable = true;
    settings = rec {
      initial_session = {
        #command = "dbus-run-session ${inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland}/bin/Hyprland 2>&1 > /tmp/hyprland.log";
        command = "Hyprland 2>&1 > /tmp/hyprland.log";
        user = "azelphur";
      };
      default_session = initial_session;
    };
  };
  security.pam.services.greetd.enableGnomeKeyring = true;
  services.gnome.gnome-keyring.enable = true;
  environment.sessionVariables = {
    EDITOR = "nvim";
    QT_STYLE_OVERRIDE = "Breeze";
    NIXOS_OZONE_WL = "1";
  };

  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/irblack.yaml";
  #stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
  stylix.enable = true;
  stylix.autoEnable = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = false;
  boot.loader.systemd-boot.configurationLimit = 10;
  boot.loader.efi.canTouchEfiVariables = true;

  time.timeZone = "Europe/London";

  i18n.defaultLocale = "en_GB.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "colemak";
    #useXkbConfig = true; # use xkb.options in tty.
  };

  fonts = {
    packages = [
      pkgs.font-awesome
      #pkgs.nerdfonts
    ];
  };

  services.pipewire = {
    enable = true;
    pulse.enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.azelphur = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "adbusers" "networkmanager" "dialout"]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
    ];
    shell = pkgs.zsh;
  };

  environment.systemPackages = with pkgs; [
    inputs.rose-pine-hyprcursor.packages.${pkgs.system}.default
    sbctl
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    git
    wget
    killall
    libsForQt5.breeze-qt5
    (python3.withPackages(ps: with ps; [ 
      python312Packages.requests
      python312Packages.virtualenv
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

