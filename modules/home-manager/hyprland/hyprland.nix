{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    hyprlandPlugins.hy3
    (pkgs.writeShellScriptBin "grimblast-wrapper" ''
      hyprctl clients -j | jq -r ".[].address" | xargs -I {} hyprctl setprop address:{} opaque on > /dev/null
      grimblast "$@"
      hyprctl clients -j | jq -r ".[].address" | xargs -I {} hyprctl setprop address:{} opaque ofi > /dev/null
    '')
  ];
  wayland.windowManager.hyprland.enable = true;
  wayland.windowManager.hyprland.settings = {
    plugin = "${pkgs.hyprlandPlugins.hy3}/lib/libhy3.so";
    "$mainMod" = "SUPER";
    "$shiftMod" = "SUPER_SHIFT";
    exec-once = [
      "waybar"
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
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    ".bin/cursor_zoom_factor.py".source = scripts/cursor_zoom_factor.py;
  };
}
