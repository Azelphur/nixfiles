{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    rofi
  ];
  programs.rofi.enable = true;
  #programs.rofi.theme = "~/.config/rofi/theme.rasi";
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    ".config/rofi/theme_old.rasi".text = ''
/*
 * ROFI color theme
 *
 * Based on Something Found in the Internet
 *
 * User: Contributors
 * Copyright: *!
 */

configuration {
  font: "JetBrainsMono Nerd Font Medium 25";

  drun {
    display-name: "";
  }

  run {
    display-name: "";
  }

  window {
    display-name: "";
  }

  timeout {
    delay: 10;
    action: "kb-cancel";
  }
}

* {
  border: 0;
  margin: 0;
  padding: 0;
  spacing: 0;

  bg: #151515;
  bg-alt: #232323;
  fg: #FFFFFF;
  fg-alt: #424242;

  background-color: @bg;
  text-color: @fg;
}

window {
  transparency: "real";
  width: 1000px;
}

mainbox {
  children: [inputbar, listview];
}

inputbar {
  background-color: @bg-alt;
  children: [prompt, entry];
}

entry {
  background-color: inherit;
  padding: 12px 3px;
}

prompt {
  background-color: inherit;
  padding: 12px;
}

listview {
  lines: 8;
}

element {
  children: [element-icon, element-text];
}

element-icon {
  padding: 10px 10px;
  size: 3ch;
}

element-text {
  padding: 10px 0;
  text-color: @fg-alt;
}

element-text selected {
  text-color: @fg;
}
    '';
  };
}
