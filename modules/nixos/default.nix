{ config, lib, pkgs, inputs, ... }:

{
  imports = [
    inputs.home-manager.nixosModules.default
  ];
  nix.settings.experimental-features = ["nix-command" "flakes" ];
  boot.supportedFilesystems = [ "ntfs" ];
  nixpkgs.config.allowUnfree = true;
  programs.hyprland.enable = true;
  programs.git = {
    enable = true;
    config = {
      user.name = "azelphur";
      user.email = "azelphur@azelphur.com";
      init.defaultBranch = "main";
      safe.directory = "etc/nixos";
    };
  };
  programs.zsh.enable = true;
  boot.plymouth.enable = true;
  services.getty.autologinUser = "azelphur";
  boot.initrd.systemd.enable = true;
  services.greetd = {
    enable = true;
    settings = rec {
      initial_session = {
        command = "dbus-run-session ${pkgs.hyprland}/bin/hyprland 2>&1 > /tmp/hyprland.log";
        user = "azelphur";
      };
      default_session = initial_session;
    };
  };

  environment.sessionVariables = {
    QT_STYLE_OVERRIDE = "Breeze";
    NIXOS_OZONE_WL = "1";
  };

  #stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/ayu-dark.yaml";
  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/catppuccin-mocha.yaml";
  stylix.enable = true;
  stylix.autoEnable = true;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
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
      pkgs.nerdfonts
    ];
  };

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.azelphur = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" ]; # Enable ‘sudo’ for the user.
    packages = with pkgs; [
    ];
    shell = pkgs.zsh;
  };

  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    git
    wget
    killall
    libsForQt5.breeze-qt5
    (python3.withPackages(ps: with ps; [ python312Packages.virtualenv ]))
  ];

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;
}

