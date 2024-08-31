{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
  ];
  #programs.rofi.theme = "~/.config/rofi/theme.rasi";
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    ".config/rofi/rasi".text = ''
/*
 * ROFI color theme
 *
 * Based on Something Found in the Internet
 *
 * User: Contributors
 * Copyright: *!
 */
    '';
  };
}
