{ configs, pkgs, inputs, ... }:

{
  home.packages = with pkgs; [
    (pkgs.writeShellScriptBin "grimblast-wrapper" ''
      hyprctl clients -j | jq -r ".[].address" | xargs -I {} hyprctl setprop address:{} opaque on > /dev/null
      grimblast "$@"
      hyprctl clients -j | jq -r ".[].address" | xargs -I {} hyprctl setprop address:{} opaque ofi > /dev/null
    '')
  ];
  wayland.windowManager.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    plugins = [
      inputs.hy3.packages.x86_64-linux.hy3
      inputs.hypr-dynamic-cursors.packages.${pkgs.system}.hypr-dynamic-cursors
    ];
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
        "waybar"
        "nextcloud"
        "gnome-keyring-daemon"
      ];
      bindd = [
        "$mainMod, Return, Launch terminal emulator, exec, kitty"
        "$mainMod, Space, Launch Rofi, exec, fuzzel"
        "$shiftMod, Q, Close, killactive"
        "$mainMod, F, Fullscreen, fullscreen"
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
        "$mainMod, mouse_up, Zoom Out, exec, python /home/azelphur/.bin/cursor_zoom_factor.py out"
        "$mainMod, mouse_down, Zoom In, exec, python /home/azelphur/.bin/cursor_zoom_factor.py in"
        "$mainMod, minus, Zoom Out, exec, python /home/azelphur/.bin/cursor_zoom_factor.py out"
        "$mainMod, equal, Zoom In, exec, python /home/azelphur/.bin/cursor_zoom_factor.py in"
        "$shiftMod, left, Move window left, hy3:movewindow, l"
        "$shiftMod, right, Move window right, hy3:movewindow, r"
        "$shiftMod, up, Move window up, hy3:movewindow, u"
        "$shiftMod, down, Move window down, hy3:movewindow, d"
        "$mainMod, H, Horizontal split, hy3:makegroup, h"
        "$mainMod, V, Vertical split, hy3:makegroup, v"
        "$shiftMod, H, Change to horizontal split, hy3:changegroup, h"
        "$shiftMod, V, Change to vertical split, hy3:changegroup, v"
      ];
      bindm = [
        "$mainMod, mouse:272, movewindow"
        "$mainMod, mouse:273, resizewindow"
      ];
      general = {
        #"col.active_border" = "0000FF 0000FF 0000FF 45deg";
        #"col.inactive_border" = "333333 333333";

        gaps_in = 5;
        gaps_out = 10;
        border_size = 2;

        layout = "hy3";
      };
      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
        force_default_wallpaper = 0;
      };
      input = {
        kb_layout = "gb,gb";
        kb_variant = "colemak,";
        kb_options = "grp:alt_shift_toggle";
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
        drop_shadow = true;
        shadow_range = 4;
        shadow_render_power = 3;
      };

      xwayland = {
        force_zero_scaling = true;
      };

      binds = {
        scroll_event_delay = 0;
      };
      windowrulev2 = [
        "opacity 1.0 0.8,class:(.*)"
        "opacity 1.0 1.0,title:(.*)(- YouTube)(.*)"
        "opacity 1.0 1.0,class:^(com\.github\.iwalton3\.jellyfin-media-player)$"
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
