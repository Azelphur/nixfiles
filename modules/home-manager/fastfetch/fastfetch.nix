{ config, pkgs, ... }:

{
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    ".assets/nixos.png".source = ./nixos.png;
  };
  programs.fastfetch = {
    enable = true;
    settings = {
      modules = [
        "title"
        "separator"
        "os"
        "host"
        "kernel"
        "uptime"
        "shell"
        {
          type = "display";
          format = "{1}x{2} @ {3}Hz";
        }
        "de"
        "wm"
        "terminal"
        "cpu"
        "gpu"
        "memory"
        "swap"
        "disk"
        "localip"
        {
          type = "battery";
          key = "Battery";
        }
        "poweradapter"
        "break"
        "colors"
      ];
    };
  };
}
