{ config, pkgs, ... }:

{
  imports = [
    ../hyprland/hyprland.nix
    ../hyprlock/hyprlock.nix
    ../waybar/waybar.nix
    ../stylix/stylix.nix
    ../kitty/kitty.nix
    ../zsh/zsh.nix
    ../nixvim/nixvim.nix
    ../dunst/dunst.nix
    ../fastfetch/fastfetch.nix
    ../scripts/scripts.nix
    ../fuzzel/fuzzel.nix
    ../cliphist/cliphist.nix
    ../nixcord/nixcord.nix
    ../yazi/yazi.nix
  ];
  qt.enable = true;
  nixpkgs.config.allowUnfree = true;
  programs.thunderbird = {
    enable = true;
    profiles.default = {
      isDefault = true;
    };
  };
  #services.network-manager-applet.enable = true;
  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = with pkgs; [
    # # Adds the 'hello' command to your environment. It prints a friendly
    # # "Hello, world!" when run.
    # pkgs.hello

    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    # Must be ran with WEBKIT_DISABLE_DMABUF_RENDERER=1 until graphics driver update
    #orca-slicer
    element-desktop
    nextcloud-client
    lcov
    dig
    mtr
    nmap
    tigervnc
    pwvucontrol
    moonlight-qt
    android-tools
    ffmpeg-full
    mpv
    vlc
    file
    pre-commit
    jq
    heroku
    libnotify
    libreoffice
    grimblast
    wl-clipboard
    inkscape
    jellyfin-media-player
    google-chrome
    playerctl
    grimblast
    gimp
    networkmanagerapplet
    brightnessctl
    slack
    firefox
    pavucontrol
    libsForQt5.kate
    spotify
    btop
    electrum
    pulseaudio # Even though we use pipewire, we use pactl for waybar volume control
    unzip
    openscad-unstable
    flutterPackages-source.stable
    android-studio
  ];
  home.sessionPath = [
    "$HOME/.bin"
  ];
}
