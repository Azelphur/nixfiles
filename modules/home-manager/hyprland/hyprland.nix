{ config, pkgs, ... }:

{
  wayland.windowManager.hyprland.enable = true;
  wayland.windowManager.hyprland.settings = {
    "$mainMod" = "SUPER";
    "$shiftMod" = "SUPER_SHIFT";
    exec-once = [
      "waybar"
    ];
    bindd = [
      "$mainMod, Return, Launch terminal emulator, exec, kitty"
      "$mainMod, Space, Launch Rofi, exec, rofi -show drun"
      "$shiftMod, Q, Close, killactive"
      "$mainMod, F, Fullscreen, fullscreen"
      "$shiftMod, Space, Toggle Floating, togglefloating"
      ", XF86AudioRaiseVolume, Raise Volume, exec, pactl set-sink-volume @DEFAULT_SINK@ +5%"
      ", XF86AudioLowerVolume, Lower Volume, exec, pactl set-sink-volume @DEFAULT_SINK@ -5%"
      ", XF86AudioMute, Mute Volume, exec, pactl set-sink-mute @DEFAULT_SINK@ toggle"
      ", XF86MonBrightnessUp, Brightness Up, exec, brightnessctl s +5%"
      ", XF86MonBrightnessDown, Brightness Down, exec, brightnessctl s 5%-"
      ", XF86AudioPlay, Media Play, exec, playerctl play-pause"
      ", XF86AudioNext, Media Next, exec, playerctl next"
      ", XF86AudioPrev, Media Previous, exec, playerctl previous"
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
      kb_layout = "gb";
      kb_variant = "colemak";
      follow_mouse = 1;
      touchpad = {
        natural_scroll = false;
	disable_while_typing = false;
	tap-to-click = false;
      };
    };
    
    windowrulev2 = "float,class:(Rofi)";

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
  };
}
