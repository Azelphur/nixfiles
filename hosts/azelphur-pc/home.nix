{ config, pkgs, inputs, lib, ... }:

let
  left_monitor = "HDMI-A-2";
  top_monitor = "DP-4";
  bottom_monitor = "DP-1";
  right_monitor = "DP-5";
in
{
  imports = [
    ../../modules/home-manager/default/default.nix
    inputs.nixvim.homeModules.nixvim
  ];
#  xdg.configFile."openvr/openvrpaths.vrpath".text = ''
#    {
#      "config" :
#      [
#        "~/.local/share/Steam/config"
#      ],
#      "external_drivers" : null,
#      "jsonid" : "vrpathreg",
#      "log" :
#      [
#        "~/.local/share/Steam/logs"
#      ],
#      "runtime" :
#      [
#        "${pkgs.opencomposite}/lib/opencomposite"
#      ],
#      "version" : 1
#    }
#  '';
#  xdg.configFile."openxr/1/active_runtime.json".source = "${pkgs.monado}/share/openxr/1/openxr_monado.json";
  home.packages = with pkgs; [
    v4l-utils
  ];
  services.dunst.settings.global.monitor = "${top_monitor}";
  wayland.windowManager.hyprland.settings = {
    monitor = [
      "${left_monitor}, 3840x2160@60, 0x0, 1.333333, transform, 1"
      "${top_monitor}, 5120x1440@240, 1620x0, 1, transform, 2, bitdepth, 8"
      "${bottom_monitor}, 5120x1440@240, 1620x1440, 1, transform, 0, bitdepth, 8"
      "${right_monitor}, 3840x2160@60, 6740x0, 1.333333, transform, 3"
    ];
    exec-once = [
      "uwsm app -- ${pkgs.writeScriptBin "fix-monitors.sh" (builtins.readFile ./fix-monitors.sh)}/bin/fix-monitors.sh lock"
      "uwsm app -- hyprlock --no-fade-in --immediate-render --grace 0"
      # Webcam autofocus is terrible, force focus.
      "uwsm app -- v4l2-ctl -d /dev/video3 --set-ctrl=focus_automatic_continuous=0"
      "uwsm app -- v4l2-ctl -d /dev/video3 --set-ctrl=focus_absolute=0"
      "uwsm app -- streamcontroller -b"
      "[workspace 11 silent] uwsm app -- element-desktop"
      "[workspace 12 silent] uwsm app -- spotify"
      "[workspace 12 silent] uwsm app -- thunderbird"
    ];
    bindd = [
      ", XF86Tools, Swap to last clipboard entry, exec, uwsm app -- cliphist list | head -n 2 | tail -n 1 | cliphist decode | wl-copy" # F13 / fn+F1
      ", XF86Launch5, Toggle headphones / speaker, exec, /home/azelphur/.bin/swap-audio-sources.sh" # F14 / fn+F2
      ", XF86Launch6, Color picker, exec, uwsm app -- hyprpicker | wl-copy" # F15 / fn+F3
      # XF86Launch7 / XF86Launch7
      ", XF86Calculator, Launch Firefox, exec, uwsm app -- firefox" # Circle button (far left)
      ", XF86Mail, Launch Terminal, exec, uwsm app -- kitty" # Triangle button (second)
      ", Help, Launch File Browser, exec, uwsm app -- dolphin" # Square button (third)
      ", Cancel, Screenshot, exec, uwsm app -- grimblast copysave area" # Cross button (last)
    ];
    windowrulev2 = [
      "workspace 11 silent,class:discord"
    ];
    input = {
      kb_layout = "gb";
    };
#    workspace = [] ++ (
#      builtins.concatLists (builtins.genList udo 
#          i: let
#	    monitors = ["HDMI-A-1" "DP-2" "DP-1" "DP-3"];
#	    ws = let
#	      x = i + 10;
#	    in
#	      builtins.toString (x);
#	    monitorNum = builtins.floor i / 10;
#          in [
#	    "${ws}, monitor:${builtins.elemAt monitors monitorNum}${if (lib.trivial.mod i 10 == 1) then ", default:true" else ""}"
#          ]
#        )
#        40)
#    );
  };
  programs.hyprlock.settings = lib.mkForce {
    general = {
      disable_loading_bar = true;
      grace = 0;
      hide_cursor = true;
      no_fade_in = false;
    };
    background = [
      {
        monitor = "${bottom_monitor}"; # Bottom
        path = "/home/azelphur/.wallpaper/bottom.png";
      }
      {
        monitor = "${top_monitor}"; # Top
        path = "/home/azelphur/.wallpaper/top.png";
      }
      {
        monitor = "${right_monitor}"; # Right
        path = "/home/azelphur/.wallpaper/right.png";
      }
      {
        monitor = "${left_monitor}"; # Left
        path = "/home/azelphur/.wallpaper/left.png";
      }
    ];
    input-field = {
        monitor = "${bottom_monitor}";
        size = "320, 50";
        outline_thickness = 3;
        dots_size = 0.33; # Scale of input-field height, 0.2 - 0.8
        dots_spacing = 0.15; # Scale of dots' absolute size, 0.0 - 1.0
        dots_center = false;
        dots_rounding = -1; # -1 default circle, -2 follow input-field rounding
        outer_color = "rgb(151515)";
        inner_color = "rgb(200, 200, 200)";
        font_color = "rgb(10, 10, 10)";
        #fade_on_empty = true
        fade_timeout = 1000; # Milliseconds before fade_on_empty is triggered.
        placeholder_text = "<i>Input Password...</i>"; # Text rendered in the input box when it's empty.
        hide_input = false;
        rounding = -1; # -1 means complete rounding (circle/oval)
        check_color = "rgb(204, 136, 34)";
        fail_color = "rgb(204, 34, 34)"; # if authentication failed, changes outer_color and fail message color
        fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>"; # can be set to empty
        fail_transition = 300; # transition time in ms between normal outer_color and fail_color
        capslock_color = -1;
        numlock_color = -1;
        bothlock_color = -1; # when both locks are active. -1 means don't change outer color (same for above)
        invert_numlock = false; # change color if numlock is off
        swap_font_color = false; # see below
        position = "0, -20";
        halign = "center";
        valign = "center";
    };
  };
  wayland.windowManager.hyprland.extraConfig = ''
# Begin monitor HDMI-A-2
workspace = 11, monitor:HDMI-A-2, default:true
workspace = 12, monitor:HDMI-A-2
workspace = 13, monitor:HDMI-A-2
workspace = 14, monitor:HDMI-A-2
workspace = 15, monitor:HDMI-A-2
workspace = 16, monitor:HDMI-A-2
workspace = 17, monitor:HDMI-A-2
workspace = 18, monitor:HDMI-A-2
workspace = 19, monitor:HDMI-A-2
workspace = 10, monitor:HDMI-A-2
bind = $mainMod, 1, submap, HDMI-A-2-workspace
submap = HDMI-A-2-workspace
bindrt = $mainMod, SUPER_L, submap, reset
bind = $mainMod, 1, workspace, 11
bind = $mainMod, 1, submap, reset
bind = $mainMod, 2, workspace, 12
bind = $mainMod, 2, submap, reset
bind = $mainMod, 3, workspace, 13
bind = $mainMod, 3, submap, reset
bind = $mainMod, 4, workspace, 14
bind = $mainMod, 4, submap, reset
bind = $mainMod, 5, workspace, 15
bind = $mainMod, 5, submap, reset
bind = $mainMod, 6, workspace, 16
bind = $mainMod, 6, submap, reset
bind = $mainMod, 7, workspace, 17
bind = $mainMod, 7, submap, reset
bind = $mainMod, 8, workspace, 18
bind = $mainMod, 8, submap, reset
bind = $mainMod, 9, workspace, 19
bind = $mainMod, 9, submap, reset
bind = $mainMod, 0, workspace, 10
bind = $mainMod, 0, submap, reset
bind= , escape, submap, reset
submap = reset

bind = $ctrlMod, 1, submap, HDMI-A-2-movetoworkspace
submap = HDMI-A-2-movetoworkspace
bindrt = $ctrlMod, SUPER_L, submap, reset
bind = $ctrlMod, 1, movetoworkspace, 11
bind = $ctrlMod, 1, submap, reset
bind = $ctrlMod, 2, movetoworkspace, 12
bind = $ctrlMod, 2, submap, reset
bind = $ctrlMod, 3, movetoworkspace, 13
bind = $ctrlMod, 3, submap, reset
bind = $ctrlMod, 4, movetoworkspace, 14
bind = $ctrlMod, 4, submap, reset
bind = $ctrlMod, 5, movetoworkspace, 15
bind = $ctrlMod, 5, submap, reset
bind = $ctrlMod, 6, movetoworkspace, 16
bind = $ctrlMod, 6, submap, reset
bind = $ctrlMod, 7, movetoworkspace, 17
bind = $ctrlMod, 7, submap, reset
bind = $ctrlMod, 8, movetoworkspace, 18
bind = $ctrlMod, 8, submap, reset
bind = $ctrlMod, 9, movetoworkspace, 19
bind = $ctrlMod, 9, submap, reset
bind = $ctrlMod, 0, movetoworkspace, 10
bind = $ctrlMod, 0, submap, reset
bind= , escape, submap, reset
submap = reset

bind = $shiftMod, 1, submap, HDMI-A-2-movetoworkspacesilent
submap = HDMI-A-2-movetoworkspacesilent
bindrt = $shiftMod, SUPER_L, submap, reset
bind = $shiftMod, 1, movetoworkspacesilent, 11
bind = $shiftMod, 1, submap, reset
bind = $shiftMod, 2, movetoworkspacesilent, 12
bind = $shiftMod, 2, submap, reset
bind = $shiftMod, 3, movetoworkspacesilent, 13
bind = $shiftMod, 3, submap, reset
bind = $shiftMod, 4, movetoworkspacesilent, 14
bind = $shiftMod, 4, submap, reset
bind = $shiftMod, 5, movetoworkspacesilent, 15
bind = $shiftMod, 5, submap, reset
bind = $shiftMod, 6, movetoworkspacesilent, 16
bind = $shiftMod, 6, submap, reset
bind = $shiftMod, 7, movetoworkspacesilent, 17
bind = $shiftMod, 7, submap, reset
bind = $shiftMod, 8, movetoworkspacesilent, 18
bind = $shiftMod, 8, submap, reset
bind = $shiftMod, 9, movetoworkspacesilent, 19
bind = $shiftMod, 9, submap, reset
bind = $shiftMod, 0, movetoworkspacesilent, 10
bind = $shiftMod, 0, submap, reset
bind= , escape, submap, reset
submap = reset

# End monitor HDMI-A-2

# Begin monitor DP-4
workspace = 21, monitor:DP-4, default:true
workspace = 22, monitor:DP-4
workspace = 23, monitor:DP-4
workspace = 24, monitor:DP-4
workspace = 25, monitor:DP-4
workspace = 26, monitor:DP-4
workspace = 27, monitor:DP-4
workspace = 28, monitor:DP-4
workspace = 29, monitor:DP-4
workspace = 20, monitor:DP-4
bind = $mainMod, 2, submap, DP-4-workspace
submap = DP-4-workspace
bindrt = $mainMod, SUPER_L, submap, reset
bind = $mainMod, 1, workspace, 21
bind = $mainMod, 1, submap, reset
bind = $mainMod, 2, workspace, 22
bind = $mainMod, 2, submap, reset
bind = $mainMod, 3, workspace, 23
bind = $mainMod, 3, submap, reset
bind = $mainMod, 4, workspace, 24
bind = $mainMod, 4, submap, reset
bind = $mainMod, 5, workspace, 25
bind = $mainMod, 5, submap, reset
bind = $mainMod, 6, workspace, 26
bind = $mainMod, 6, submap, reset
bind = $mainMod, 7, workspace, 27
bind = $mainMod, 7, submap, reset
bind = $mainMod, 8, workspace, 28
bind = $mainMod, 8, submap, reset
bind = $mainMod, 9, workspace, 29
bind = $mainMod, 9, submap, reset
bind = $mainMod, 0, workspace, 20
bind = $mainMod, 0, submap, reset
bind= , escape, submap, reset
submap = reset

bind = $ctrlMod, 2, submap, DP-4-movetoworkspace
submap = DP-4-movetoworkspace
bindrt = $ctrlMod, SUPER_L, submap, reset
bind = $ctrlMod, 1, movetoworkspace, 21
bind = $ctrlMod, 1, submap, reset
bind = $ctrlMod, 2, movetoworkspace, 22
bind = $ctrlMod, 2, submap, reset
bind = $ctrlMod, 3, movetoworkspace, 23
bind = $ctrlMod, 3, submap, reset
bind = $ctrlMod, 4, movetoworkspace, 24
bind = $ctrlMod, 4, submap, reset
bind = $ctrlMod, 5, movetoworkspace, 25
bind = $ctrlMod, 5, submap, reset
bind = $ctrlMod, 6, movetoworkspace, 26
bind = $ctrlMod, 6, submap, reset
bind = $ctrlMod, 7, movetoworkspace, 27
bind = $ctrlMod, 7, submap, reset
bind = $ctrlMod, 8, movetoworkspace, 28
bind = $ctrlMod, 8, submap, reset
bind = $ctrlMod, 9, movetoworkspace, 29
bind = $ctrlMod, 9, submap, reset
bind = $ctrlMod, 0, movetoworkspace, 20
bind = $ctrlMod, 0, submap, reset
bind= , escape, submap, reset
submap = reset

bind = $shiftMod, 2, submap, DP-4-movetoworkspacesilent
submap = DP-4-movetoworkspacesilent
bindrt = $shiftMod, SUPER_L, submap, reset
bind = $shiftMod, 1, movetoworkspacesilent, 21
bind = $shiftMod, 1, submap, reset
bind = $shiftMod, 2, movetoworkspacesilent, 22
bind = $shiftMod, 2, submap, reset
bind = $shiftMod, 3, movetoworkspacesilent, 23
bind = $shiftMod, 3, submap, reset
bind = $shiftMod, 4, movetoworkspacesilent, 24
bind = $shiftMod, 4, submap, reset
bind = $shiftMod, 5, movetoworkspacesilent, 25
bind = $shiftMod, 5, submap, reset
bind = $shiftMod, 6, movetoworkspacesilent, 26
bind = $shiftMod, 6, submap, reset
bind = $shiftMod, 7, movetoworkspacesilent, 27
bind = $shiftMod, 7, submap, reset
bind = $shiftMod, 8, movetoworkspacesilent, 28
bind = $shiftMod, 8, submap, reset
bind = $shiftMod, 9, movetoworkspacesilent, 29
bind = $shiftMod, 9, submap, reset
bind = $shiftMod, 0, movetoworkspacesilent, 20
bind = $shiftMod, 0, submap, reset
bind= , escape, submap, reset
submap = reset

# End monitor DP-4

# Begin monitor DP-1
workspace = 31, monitor:DP-1, default:true
workspace = 32, monitor:DP-1
workspace = 33, monitor:DP-1
workspace = 34, monitor:DP-1
workspace = 35, monitor:DP-1
workspace = 36, monitor:DP-1
workspace = 37, monitor:DP-1
workspace = 38, monitor:DP-1
workspace = 39, monitor:DP-1
workspace = 30, monitor:DP-1
bind = $mainMod, 3, submap, DP-1-workspace
submap = DP-1-workspace
bindrt = $mainMod, SUPER_L, submap, reset
bind = $mainMod, 1, workspace, 31
bind = $mainMod, 1, submap, reset
bind = $mainMod, 2, workspace, 32
bind = $mainMod, 2, submap, reset
bind = $mainMod, 3, workspace, 33
bind = $mainMod, 3, submap, reset
bind = $mainMod, 4, workspace, 34
bind = $mainMod, 4, submap, reset
bind = $mainMod, 5, workspace, 35
bind = $mainMod, 5, submap, reset
bind = $mainMod, 6, workspace, 36
bind = $mainMod, 6, submap, reset
bind = $mainMod, 7, workspace, 37
bind = $mainMod, 7, submap, reset
bind = $mainMod, 8, workspace, 38
bind = $mainMod, 8, submap, reset
bind = $mainMod, 9, workspace, 39
bind = $mainMod, 9, submap, reset
bind = $mainMod, 0, workspace, 30
bind = $mainMod, 0, submap, reset
bind= , escape, submap, reset
submap = reset

bind = $ctrlMod, 3, submap, DP-1-movetoworkspace
submap = DP-1-movetoworkspace
bindrt = $ctrlMod, SUPER_L, submap, reset
bind = $ctrlMod, 1, movetoworkspace, 31
bind = $ctrlMod, 1, submap, reset
bind = $ctrlMod, 2, movetoworkspace, 32
bind = $ctrlMod, 2, submap, reset
bind = $ctrlMod, 3, movetoworkspace, 33
bind = $ctrlMod, 3, submap, reset
bind = $ctrlMod, 4, movetoworkspace, 34
bind = $ctrlMod, 4, submap, reset
bind = $ctrlMod, 5, movetoworkspace, 35
bind = $ctrlMod, 5, submap, reset
bind = $ctrlMod, 6, movetoworkspace, 36
bind = $ctrlMod, 6, submap, reset
bind = $ctrlMod, 7, movetoworkspace, 37
bind = $ctrlMod, 7, submap, reset
bind = $ctrlMod, 8, movetoworkspace, 38
bind = $ctrlMod, 8, submap, reset
bind = $ctrlMod, 9, movetoworkspace, 39
bind = $ctrlMod, 9, submap, reset
bind = $ctrlMod, 0, movetoworkspace, 30
bind = $ctrlMod, 0, submap, reset
bind= , escape, submap, reset
submap = reset

bind = $shiftMod, 3, submap, DP-1-movetoworkspacesilent
submap = DP-1-movetoworkspacesilent
bindrt = $shiftMod, SUPER_L, submap, reset
bind = $shiftMod, 1, movetoworkspacesilent, 31
bind = $shiftMod, 1, submap, reset
bind = $shiftMod, 2, movetoworkspacesilent, 32
bind = $shiftMod, 2, submap, reset
bind = $shiftMod, 3, movetoworkspacesilent, 33
bind = $shiftMod, 3, submap, reset
bind = $shiftMod, 4, movetoworkspacesilent, 34
bind = $shiftMod, 4, submap, reset
bind = $shiftMod, 5, movetoworkspacesilent, 35
bind = $shiftMod, 5, submap, reset
bind = $shiftMod, 6, movetoworkspacesilent, 36
bind = $shiftMod, 6, submap, reset
bind = $shiftMod, 7, movetoworkspacesilent, 37
bind = $shiftMod, 7, submap, reset
bind = $shiftMod, 8, movetoworkspacesilent, 38
bind = $shiftMod, 8, submap, reset
bind = $shiftMod, 9, movetoworkspacesilent, 39
bind = $shiftMod, 9, submap, reset
bind = $shiftMod, 0, movetoworkspacesilent, 30
bind = $shiftMod, 0, submap, reset
bind= , escape, submap, reset
submap = reset

# End monitor DP-1

# Begin monitor DP-5
workspace = 41, monitor:DP-5, default:true
workspace = 42, monitor:DP-5
workspace = 43, monitor:DP-5
workspace = 44, monitor:DP-5
workspace = 45, monitor:DP-5
workspace = 46, monitor:DP-5
workspace = 47, monitor:DP-5
workspace = 48, monitor:DP-5
workspace = 49, monitor:DP-5
workspace = 40, monitor:DP-5
bind = $mainMod, 4, submap, DP-5-workspace
submap = DP-5-workspace
bindrt = $mainMod, SUPER_L, submap, reset
bind = $mainMod, 1, workspace, 41
bind = $mainMod, 1, submap, reset
bind = $mainMod, 2, workspace, 42
bind = $mainMod, 2, submap, reset
bind = $mainMod, 3, workspace, 43
bind = $mainMod, 3, submap, reset
bind = $mainMod, 4, workspace, 44
bind = $mainMod, 4, submap, reset
bind = $mainMod, 5, workspace, 45
bind = $mainMod, 5, submap, reset
bind = $mainMod, 6, workspace, 46
bind = $mainMod, 6, submap, reset
bind = $mainMod, 7, workspace, 47
bind = $mainMod, 7, submap, reset
bind = $mainMod, 8, workspace, 48
bind = $mainMod, 8, submap, reset
bind = $mainMod, 9, workspace, 49
bind = $mainMod, 9, submap, reset
bind = $mainMod, 0, workspace, 40
bind = $mainMod, 0, submap, reset
bind= , escape, submap, reset
submap = reset

bind = $ctrlMod, 4, submap, DP-5-movetoworkspace
submap = DP-5-movetoworkspace
bindrt = $ctrlMod, SUPER_L, submap, reset
bind = $ctrlMod, 1, movetoworkspace, 41
bind = $ctrlMod, 1, submap, reset
bind = $ctrlMod, 2, movetoworkspace, 42
bind = $ctrlMod, 2, submap, reset
bind = $ctrlMod, 3, movetoworkspace, 43
bind = $ctrlMod, 3, submap, reset
bind = $ctrlMod, 4, movetoworkspace, 44
bind = $ctrlMod, 4, submap, reset
bind = $ctrlMod, 5, movetoworkspace, 45
bind = $ctrlMod, 5, submap, reset
bind = $ctrlMod, 6, movetoworkspace, 46
bind = $ctrlMod, 6, submap, reset
bind = $ctrlMod, 7, movetoworkspace, 47
bind = $ctrlMod, 7, submap, reset
bind = $ctrlMod, 8, movetoworkspace, 48
bind = $ctrlMod, 8, submap, reset
bind = $ctrlMod, 9, movetoworkspace, 49
bind = $ctrlMod, 9, submap, reset
bind = $ctrlMod, 0, movetoworkspace, 40
bind = $ctrlMod, 0, submap, reset
bind= , escape, submap, reset
submap = reset

bind = $shiftMod, 4, submap, DP-5-movetoworkspacesilent
submap = DP-5-movetoworkspacesilent
bindrt = $shiftMod, SUPER_L, submap, reset
bind = $shiftMod, 1, movetoworkspacesilent, 41
bind = $shiftMod, 1, submap, reset
bind = $shiftMod, 2, movetoworkspacesilent, 42
bind = $shiftMod, 2, submap, reset
bind = $shiftMod, 3, movetoworkspacesilent, 43
bind = $shiftMod, 3, submap, reset
bind = $shiftMod, 4, movetoworkspacesilent, 44
bind = $shiftMod, 4, submap, reset
bind = $shiftMod, 5, movetoworkspacesilent, 45
bind = $shiftMod, 5, submap, reset
bind = $shiftMod, 6, movetoworkspacesilent, 46
bind = $shiftMod, 6, submap, reset
bind = $shiftMod, 7, movetoworkspacesilent, 47
bind = $shiftMod, 7, submap, reset
bind = $shiftMod, 8, movetoworkspacesilent, 48
bind = $shiftMod, 8, submap, reset
bind = $shiftMod, 9, movetoworkspacesilent, 49
bind = $shiftMod, 9, submap, reset
bind = $shiftMod, 0, movetoworkspacesilent, 40
bind = $shiftMod, 0, submap, reset
bind= , escape, submap, reset
submap = reset

# End monitor DP-5


'';
  services.hyprpaper.settings = {
    splash = false;
    wallpaper = [
      {
        monitor = "${bottom_monitor}";
        path = "~/.wallpaper/bottom.png";
      }
      {
        monitor = "${top_monitor}";
        path = "~/.wallpaper/top.png";
      }
      {
        monitor = "${right_monitor}";
        path = "~/.wallpaper/right.png";
      }
      {
        monitor = "${left_monitor}";
        path = "~/.wallpaper/left.png";
      }
    ];
  };

  programs.waybar.settings.mainBar.output = "${top_monitor}";
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
