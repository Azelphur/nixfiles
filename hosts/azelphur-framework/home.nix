{ config, pkgs, inputs, lib, ... }:

{
  imports = [
    ../../modules/home-manager/default/default.nix
    inputs.nixvim.homeManagerModules.nixvim
  ];
  home.packages = with pkgs; [
      conky
  ];
  wayland.windowManager.hyprland.settings = {
    exec-once = [
      "nm-applet"
      "conky"
    ];
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
    monitor = ", preferred, auto, 1";
  };
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "azelphur";
  home.homeDirectory = "/home/azelphur";
  stylix.targets.hyprpaper.enable = lib.mkForce false;
  services.hyprpaper.settings = {
    preload = [
      "~/.wallpaper.png"
    ];
    wallpaper = [
      "eDP-1,~/.wallpaper.png"
    ];
  };

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
    ".wallpaper.png".source = ./wallpaper.png;
    ".config/conky/conky.conf".source = ./conky.conf;
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
