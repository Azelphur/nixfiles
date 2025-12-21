{ config, lib, pkgs, inputs, ...}:

{
  imports = [
    inputs.home-manager.nixosModules.default
    ./desktop.nix
    ./go-hass-agent.nix
  ];
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
    pkiBundle = "/var/lib/sbctl";
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

  boot.loader = {
    efi.canTouchEfiVariables = true;
    timeout = 1;
    systemd-boot = {
      enable = false;
      configurationLimit = 10;
    };
  };

  time.timeZone = "Europe/London";

  i18n.defaultLocale = "en_GB.UTF-8";

  console = {
    font = "Lat2-Terminus16";
    keyMap = "uk";
  };

  fonts = {
    packages = [
      pkgs.font-awesome
    ];
  };

  users.users.azelphur = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "adbusers" "networkmanager" "dialout" "input"];
    shell = pkgs.zsh;
  };

  users.users.homeassistant = {
    isNormalUser = false;
    isSystemUser = true;
    description = "Shutdown-only SSH user";
    home = "/var/empty";
    shell = "/run/current-system/sw/bin/sh";
    group = "homeassistant";

    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCyNS0gBxrQeOw95M3QSZ6n3oIbcw23gXF7mc0tDT3/mXNI+BxFQAxEyHiE0GDOtYXaswN4zCWjcgXtEKG4dPTJXI1tque1cZPlilgAcyXoK48FG5J6Ms1+Cv7ZYfNjg7Yl82pNwKDz+YF0P6fLmOYYAIM+rej1Yp43mMPcVueSRnk3i2BGxdiLQtMb8JpX1VHuUZqIOL+gjFT6sZdLMNO+gB5vYoJsUdYODO5pWOM/PA3Ov+rVbKoHKK8ErPhIMe5i7MZ7GTNxPMahq69w6HIHnXElNPBfLOmX3h+8GlNXu37epqPjmud2Gej9vE9tG/TnIzpxVGC/AMnlVs98LqKNOOGNp0uGTx5/lqTsnC0liTcKY6IUaZ3maCHT+WkjfuiMpUiL/Yo27Q2h29k1sMwZJ7iXWRJunROmQSdPw/YCeJxi0X2tGtfahw7dQSfgcj/8gB0RiMTYBRbsTf/u2xmfnp1sZpKe6Brq0Bo4YjH53u+RyN5UR25IWHA0gfuMnxs="
    ];
  };
  users.groups.homeassistant = {};

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

  services.openssh = {
    enable = true;

    extraConfig = ''
      Match User homeassistant
        # Do not allow PTY (stops interactive shells)
        PermitTTY no

        # Do not allow port forwarding, agent forwarding, or anything else
        AllowTcpForwarding no
        X11Forwarding no
        PermitTunnel no

        # Ignore any command supplied by client (ssh user@host command)
        # Always run shutdown instead
        ForceCommand /run/current-system/sw/sbin/shutdown -h now
    '';
  };

  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (
        subject.isInGroup("homeassistant") &&
        (action.id == "org.freedesktop.login1.power-off" ||
         action.id == "org.freedesktop.login1.power-off-multiple-sessions" ||
         action.id == "org.freedesktop.login1.halt" ||
         action.id == "org.freedesktop.login1.halt-multiple-sessions")
      ) {
        return polkit.Result.YES;
      }
    });
  '';

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  networking.firewall.enable = false;
}

