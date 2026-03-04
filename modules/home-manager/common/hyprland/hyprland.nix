{ configs, pkgs, inputs, ... }:

{
  home.packages = with pkgs; [
    playerctl
    pkgs.hyprpicker
    (pkgs.writeShellScriptBin "grimblast-wrapper" ''
      hyprctl clients -j | jq -r ".[].address" | xargs -I {} hyprctl setprop address:{} opaque on > /dev/null
      grimblast "$@"
      hyprctl clients -j | jq -r ".[].address" | xargs -I {} hyprctl setprop address:{} opaque ofi > /dev/null
    '')
  ];
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    plugins = with pkgs.hyprlandPlugins; [
      #hypr-dynamic-cursors
    ];
    extraConfig = ''
    submap = fit-switch
    bindrt = $mainMod, SUPER_L, submap, reset
    bind = , escape, submap, reset
    bind = $mainMod, F, layoutmsg, fit active
    bind = $mainMod, V, layoutmsg, fit visible
    bind = $mainMod, A, layoutmsg, fit all
    bind = $mainMod, E, layoutmsg, fit toend
    bind = $mainMod, B, layoutmsg, fit tobeg
    submap = reset
    '';
    settings = {
      "plugin:dynamic-cursors" = {
        # enables the plugin
        enabled = true;

        # sets the cursor behaviour, supports these values:
        # tilt    - tilt the cursor based on x-velocity
        # rotate  - rotate the cursor based on movement direction
        # stretch - stretch the cursor shape based on direction and velocity
        # none    - do not change the cursors behaviour
        mode = "none";

        # minimum angle difference in degrees after which the shape is changed
        # smaller values are smoother, but more expensive for hw cursors
        threshold = 2;

        # override the mode behaviour per shape
        # this is a keyword and can be repeated many times
        # by default, there are no rules added
        # see the dedicated `shape rules` section below!
        #shaperule = <shape-name>, <mode> (optional), <property>: <value>, ...
        #shaperule = <shape-name>, <mode> (optional), <property>: <value>, ...
        #...

        # for mode = rotate
        #rotate = {

            # length in px of the simulated stick used to rotate the cursor
            # most realistic if this is your actual cursor size
            #length = 20;

            # clockwise offset applied to the angle in degrees
            # this will apply to ALL shapes
            #offset = 0.0;
        #};

        # for mode = tilt
        #tilt = {

            # controls how powerful the tilt is, the lower, the more power
            # this value controls at which speed (px/s) the full tilt is reached
            #limit = 500;

            # relationship between speed and tilt, supports these values:
            # linear             - a linear function is used
            # quadratic          - a quadratic function is used (most realistic to actual air drag)
            # negative_quadratic - negative version of the quadratic one, feels more aggressive
            #function = "linear";
        #};

        # for mode = stretch
        #stretch {

            # controls how much the cursor is stretched
            # this value controls at which speed (px/s) the full stretch is reached
            #limit = 3000

            # relationship between speed and stretch amount, supports these values:
            # linear             - a linear function is used
            # quadratic          - a quadratic function is used
            # negative_quadratic - negative version of the quadratic one, feels more aggressive
            #function = quadratic
        #}

        # configure shake to find
        # magnifies the cursor if its is being shaken
        shake = {

            # enables shake to find
            enabled = true;

            # use nearest-neighbour (pixelated) scaling when shaking
            # may look weird when effects are enabled
            nearest = true;

            # controls how soon a shake is detected
            # lower values mean sooner
            threshold = 5.0;

            # magnification level immediately after shake start
            base = 4.0;
            # magnification increase per second when continuing to shake
            speed = 4.0;
            # how much the speed is influenced by the current shake intensitiy
            influence = 0.0;

            # maximal magnification the cursor can reach
            # values below 1 disable the limit (e.g. 0)
            limit = 0.0;

            # time in millseconds the cursor will stay magnified after a shake has ended
            timeout = 2000;

            # show cursor behaviour `tilt`, `rotate`, etc. while shaking
            effects = false;

            # enable ipc events for shake
            # see the `ipc` section below
            ipc = false;
        };
      };
      "$mainMod" = "SUPER";
      "$shiftMod" = "SUPER_SHIFT";
      exec-once = [
        "uwsm app -- discord"
      ];
      bindd = [
        "$mainMod, Return, Launch terminal emulator, exec, uwsm app -- kitty"
        "$mainMod, Space, Launch Rofi, exec, uwsm app -- fuzzel"
        "$mainMod, D, Launch Dolphin, exec, uwsm app -- dolphin"
        "$shiftMod, Q, Close, killactive"
        "$mainMod, F, Fullscreen, fullscreen"
        "$shiftMod, F, Tiled fullscreen, layoutmsg, colresize 1"
        #"$shiftMod, F, Fake fullscreen,fakefullscreen"
        "$shiftMod, Space, Toggle Floating, togglefloating"
        "$mainMod, J, Toggle split, togglesplit"
        ", XF86AudioRaiseVolume, Raise Volume, exec, pactl set-sink-volume @DEFAULT_SINK@ +5%"
        ", XF86AudioLowerVolume, Lower Volume, exec, pactl set-sink-volume @DEFAULT_SINK@ -5%"
        ", XF86AudioMute, Mute Volume, exec, pactl set-sink-mute @DEFAULT_SINK@ toggle"
        ", XF86MonBrightnessUp, Brightness Up, exec, brightnessctl s +5%"
        ", XF86MonBrightnessDown, Brightness Down, exec, brightnessctl s 5%-"
        ", XF86AudioPlay, Media Play, exec, playerctl play-pause"
        ", XF86AudioNext, Media Next, exec, playerctl next"
        ", XF86AudioPrev, Media Previous, exec, playerctl previous"
        "$mainMod, F5, Spotify Media Play, exec, playerctl --player=spotify play-pause"
        "$mainMod, F8, Spotify Media Next, exec, playerctl --player=spotify next"
        "$mainMod, F7, Spotify Media Previous, exec, playerctl --player=spotify previous"
        "$mainMod, mouse_down, Zoom In, exec, hyprctl -q keyword cursor:zoom_factor $(hyprctl getoption cursor:zoom_factor -j | jq '.float * 1.1')"
        "$mainMod, mouse_up, Zoom Out, exec, hyprctl -q keyword cursor:zoom_factor $(hyprctl getoption cursor:zoom_factor -j | jq '(.float * 0.9) | if . < 1 then 1 else . end')"
        "$shiftMod, mouse_up, Reset Zoom, exec, hyprctl -q keyword cursor:zoom_factor 1"
        "$shiftMod, mouse_down, Reset Zoom, exec, hyprctl -q keyword cursor:zoom_factor 1"
        "$shiftMod, minus, Reset Zoom, exec, hyprctl -q keyword cursor:zoom_factor 1"
        "$mainMod, O, Execute a fit opiration, submap, fit-switch"
        "$mainMod, up, Move layout up, layoutmsg, move -col"
        "$mainMod, down, Move layout down, layoutmsg, move +col"
        "$mainMod, left, Move layout left, layoutmsg, move -col"
        "$mainMod, right, Move layout right, layoutmsg, move +col"
        "$shiftMod, up, Move window left, layoutmsg, swapcol l"
        "$shiftMod, down, Move window right, layoutmsg, swapcol r" 
        "$shiftMod, left, Move window left, layoutmsg, swapcol l"
        "$shiftMod, right, Move window right, layoutmsg, swapcol r"
      ];
      binde = [
        "$mainMod, equal, exec, hyprctl -q keyword cursor:zoom_factor $(hyprctl getoption cursor:zoom_factor -j | jq '.float * 1.1')"
        "$mainMod, minus, exec, hyprctl -q keyword cursor:zoom_factor $(hyprctl getoption cursor:zoom_factor -j | jq '(.float * 0.9) | if . < 1 then 1 else . end')"
      ];
      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];
      general = {
        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;
        layout = "scrolling";
      };
      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        force_default_wallpaper = 0;
      };
      input = {
        follow_mouse = 1;
        touchpad = {
          natural_scroll = false;
          disable_while_typing = false;
          tap-to-click = false;
        };
      };
      
      decoration = {
        rounding = 10;
        blur = {
          enabled = true;
          size = 3;
          passes = 1;
        };
        shadow = {
          enabled = true;
          range = 4;
          render_power = 3;
        };
      };

      xwayland = {
        force_zero_scaling = true;
        enabled = true;
      };

      binds = {
        scroll_event_delay = 0;
      };
      windowrule = [
        {
          name = "transparency";
          "match:class" = "(.*)";
          opacity = "1.0 0.8";
        }
        {
          name = "Youtube";
          "match:title" = "(.*)(- YouTube)(.*)";
          opacity = "1.0 1.0";
        }
        {
          name = "Jellyfin";
          "match:class" = "org.jellyfin.JellyfinDesktop";
          opacity = "1.0 1.0";
        }
      ];
    };
  };
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    ".bin/cursor_zoom_factor.py".source = scripts/cursor_zoom_factor.py;
  };
}
