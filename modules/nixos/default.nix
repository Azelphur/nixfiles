{ config, lib, pkgs, inputs, ...}:

let
  go-hass-agent = pkgs.buildGoModule (finalAttrs: {
    pname = "go-hass-agent";
    version = "13.2.7";

    src = pkgs.fetchFromGitHub {
      owner = "joshuar";
      repo = "go-hass-agent";
      tag = "v${finalAttrs.version}";
      hash = "sha256-nec5gH/p65sfxNDD+5TEc7POP7B2MOA23aMqJ9aXAz8=";
    };

    nativeBuildInputs = with pkgs; [
      pkg-config
    ];

    subPackages = [ "." ];

    buildInputs = with pkgs; [
      xorg.libX11
      xorg.libXrandr
      xorg.libXxf86vm
      xorg.libXi
      xorg.libXcursor
      xorg.libXinerama
      xorg.libXext
      xorg.libxcb
      mesa
      glfw
    ];

    vendorHash = "sha256-PVicvYGaZxNVUbmNCEGUd4BZklhgaSMKpeiy898YTbM=";
    meta = with pkgs.lib; {
      description = "Go-based Home Assistant agent";
      homepage = "https://github.com/joshuar/go-hass-agent";
      license = licenses.mit;
    };
  });
in
{
  imports = [
    inputs.home-manager.nixosModules.default
  ];
  services.fwupd.enable = true;
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
  virtualisation.docker = {
    enable = true;
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
    go-hass-agent
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

