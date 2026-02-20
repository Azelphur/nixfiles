{ pkgs, ... }:

{
  services.flameshot = {
    enable = true;
    settings = {
      General = {
        useGrimAdapter = true;
      };
    };
  };
  wayland.windowManager.hyprland.settings = {
    windowrule = [
      {
        name = "flameshot-multi-display-fix";
        "match:title" = "flameshot";
        animation = "fade";
        rounding = 0;
        border_size = 0;
        fullscreen_state = "0 0";
        float = "on";
        pin = "on";
        monitor = "HDMI-A-2";
        move = "0 0";
        size = "8362 2882";
      }
    ];
  };
}
