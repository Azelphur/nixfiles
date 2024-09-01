{ config, pkgs, ... }:

{
  #home.packages = with pkgs; [
  #];
  #programs.rofi.theme = "~/.config/rofi/theme.rasi";
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    ".bin/approval".source = ./approval/approval.py;
    ".local/share/applications/approval.desktop".source = ./approval/approval.desktop;
  };
}
