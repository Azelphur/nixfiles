{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    kitty
  ];
  home.sessionVariables = {
    TERMINAL = "kitty";
  };
  xdg = {
    mimeApps = {
      enable = true;
      defaultApplications = {
        x-terminal-emulator = "kitty.desktop";
      };
    };
  };
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
