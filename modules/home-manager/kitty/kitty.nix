{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    kitty
  ];
  programs.kitty = {
    enable = true;
    settings = {
      scrollback_lines = 99999;
      enable_audio_bell = false;
      close_on_child_death = false;
      confirm_os_window_close = 0;
    };
  };
}
