{ config, pkgs, inputs, ... }:

{
  imports = [
    ../../modules/home-manager/default/default.nix
    inputs.nixvim.homeManagerModules.nixvim
  ];
  wayland.windowManager.hyprland.settings = {
    bindd = [] ++ (
      # workspaces
      # binds $mod + [shift +] {1..10} to [move to] workspace {1..10}
      builtins.concatLists (builtins.genList (
          x: let
            ws = let
              c = (x + 1) / 10;
            in
              builtins.toString (x + 1 - (c * 10));
          in [
            "$mainMod, ${ws}, Switch to workspace ${ws}, workspace, ${toString (x + 1)}"
            "$shiftMod, ${ws}, Move active window to workspace ${ws}, movetoworkspacesilent, ${toString (x + 1)}"
          ]
        )
        10)
    );
    monitor = [
      #"DP-4, 5120x1440@120, 1619x1440, 1, transform, 0, bitdepth, 10" # Bottom
      "DP-4, 1920x1080@60, 1619x1440, 1, transform, 0, bitdepth, 10" # Bottom
      #"HDMI-A-2, 3840x2160@60, 0x0, 1.333333, transform, 1" # Left
      "HDMI-A-2, 1920x1080@60, 0x0, 1.333333, transform, 1" # Left
      #"DP-6, 3840x2160@60, 6739x0, 1.333333, transform, 3" # Right
      "DP-6, 1920x1080@60, 6739x0, 1.333333, transform, 3" # Right
      #"DP-5, 5120x1440@120, 1619x0, 1, transform, 2, bitdepth, 10" # Top
      "DP-5, 1920x1080@60, 1619x0, 1, transform, 2, bitdepth, 10" # Top
    ];
    exec-once = [
      "sleep 1;hyprctl keyword monitor DP-4, 5120x1440@120, 1619x1440, 1, transform, 0, bitdepth, 10" # Bottom
      "sleep 1;hyprctl keyword monitor DP-5, 5120x1440@120, 1619x0, 1, transform, 2, bitdepth, 10" # Top
      "sleep 1;hyprctl keyword monitor DP-6, 3840x2160@60, 6739x0, 1.333333, transform, 3" # Right
      "sleep 1;hyprctl keyword monitor HDMI-A-2, 3840x2160x, 0x0, 1.333333, transform, 1" # Left
    ];
  };
  services.hyprpaper.settings = {
    preload = [
      "~/.wallpaper/left.png"
      "~/.wallpaper/right.png"
      "~/.wallpaper/top.png"
      "~/.wallpaper/bottom.png"
    ];
    wallpaper = [
      "DP-4,~/.wallpaper/bottom.png"
      "DP-5,~/.wallpaper/top.png"
      "DP-6,~/.wallpaper/right.png"
      "HDMI-A-2,~/.wallpaper/left.png"
    ];
  };
  programs.waybar.settings.mainBar.output = "DP-5";
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "azelphur";
  home.homeDirectory = "/home/azelphur";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/azelphur/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    # EDITOR = "emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}
