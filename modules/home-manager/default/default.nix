{ config, pkgs, ... }:

{
  imports = [
    ../hyprland/hyprland.nix
    ../hyprlock/hyprlock.nix
    ../rofi/rofi.nix
    ../waybar/waybar.nix
    ../stylix/stylix.nix
    ../kitty/kitty.nix
    ../zsh/zsh.nix
    ../nixvim/nixvim.nix
    ../dunst/dunst.nix
    ../fastfetch/fastfetch.nix
  ];
  qt.enable = true;
  nixpkgs.config.allowUnfree = true;
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
    grimblast
    hyprland
    hyprlandPlugins.hy3
    wl-clipboard
    inkscape
    jellyfin-media-player
    google-chrome
    playerctl
    grimblast
    gimp
    networkmanagerapplet
    nautilus
    brightnessctl
    slack
    dolphin
    vesktop
    firefox
    pavucontrol
    kate
    spotify
    btop
    pulseaudio # Even though we use pipewire, we use pactl for waybar volume control
  ];
  home.sessionPath = [
    "$HOME/.bin"
  ];
}
