{ config, pkgs, inputs, ... }:

{
  imports = [
    ../common/user.nix
  ];
  # Increase resources available to dev VM
  virtualisation.vmVariant = {
    virtualisation = {
      memorySize = 4096; 
      cores = 8;
      diskSize = 32768;
      resolution.x = 1920;
      resolution.y = 1080;
    };
  };
  virtualisation.diskSize = 32768;

  hardware.enableAllFirmware = true;

  nix.gc = {
    automatic = true;
    randomizedDelaySec = "14m";
    options = "--delete-older-than 10d";
  };

  nix.distributedBuilds = true;
  nix.settings.builders-use-substitutes = true;

  nix.buildMachines = [
    {
      hostName = "10.0.1.1";
      system = "x86_64";
      protocol = "ssh-ng";
      sshUser = "root";
      maxJobs = 12;
      speedFactor = 5;
      supportedFeatures = [ "big-parallel" ];
    }
  ];

  nix.settings = {
    substituters = [
      "https://hyprland.cachix.org"
      "https://attic.home.azelphur.com/cache"
    ];

    trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "cache:tSCNZW+e3Qm6uxob5v3x1k84sjosDbXWa+Pd8JQ+cwE="
    ];
  };

  sops.defaultSopsFormat = "yaml";
  sops.age.keyFile = "/var/lib/sops-nix/keys.txt";

  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  networking.networkmanager.enable = true;

  time.timeZone = "Europe/London";

  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_GB.UTF-8";
    LC_IDENTIFICATION = "en_GB.UTF-8";
    LC_MEASUREMENT = "en_GB.UTF-8";
    LC_MONETARY = "en_GB.UTF-8";
    LC_NAME = "en_GB.UTF-8";
    LC_NUMERIC = "en_GB.UTF-8";
    LC_PAPER = "en_GB.UTF-8";
    LC_TELEPHONE = "en_GB.UTF-8";
    LC_TIME = "en_GB.UTF-8";
  };

  services.xserver.xkb = {
    layout = "gb";
    variant = "";
  };

  console.keyMap = "uk";

  services.printing.enable = true;
  services.avahi.enable = true;

  security.polkit.enable = true;

  my.user = {
    name = "azelphur";
    fullName = "Alfie \"Azelphur\" Day";
    email = "azelphur@azelphur.com";
    authorizedKeys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJGlxz3OU04uZqYfXnyOzU6bhg/1Wx4Jzabn+AxILYXr azelphur@azelphur-pc"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMnnUhRr3jdQtnCvi7JZzAc9gJflRLRT31gnKrtYRNyX azelphur@azelphur-framework"
    ];
  };

  nix.settings.trusted-users = [ "root" config.my.user.name ];

  programs.zsh.enable = true;
  users.users.root = {
    openssh.authorizedKeys.keys = config.my.user.authorizedKeys;
  };
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.${config.my.user.name} = {
    description = config.my.user.fullName;
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" "video" ];
    initialPassword = "a"; 
    shell = pkgs.zsh;
    openssh.authorizedKeys.keys = config.my.user.authorizedKeys;
  };

  programs.git = {
    enable = true;
    config = {
      user.name = config.my.user.name;
      user.email = config.my.user.email;
      init.defaultBranch = "main";
    };
  };

  nixpkgs.config.allowUnfree = true;

  services.openssh.enable = true;

  networking.firewall.enable = false;

  programs.iotop.enable = true;
  # Required for iotop
  boot.kernel.sysctl = {
    "kernel.task_delayacct" = 1;
  };

  environment.systemPackages = with pkgs; [
    tpm2-tss
    busybox
    attic-client
    age
    sops
    kitty.terminfo
    sbctl
    wget
    screen
    git
    killall
    pciutils
    usbutils
    dmidecode
    dig
    mtr
    nmap
    btop
    unzip
    whois
    p7zip
    jq
    smartmontools
    (python3.withPackages(ps: with ps; [ 
      requests
      virtualenv
    ]))
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
}
