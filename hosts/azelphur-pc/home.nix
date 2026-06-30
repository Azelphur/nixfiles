{ config, pkgs, inputs, lib, monitors, ... }:

let
  left_monitor = "HDMI-A-2";
  top_monitor = "DP-4";
  bottom_monitor = "DP-1";
  right_monitor = "DP-5";
  simrig_monitor = "DP-3";
  toggleSimrig = import ./scripts/toggle-simrig.nix {
    inherit pkgs monitors;
  };
  eliteIntel = pkgs.callPackage ../../pkgs/elite-intel.nix { };
in
{
  imports = [
    ../../modules/home-manager/roles/default.nix
  ];
  home.packages = [
    toggleSimrig
    eliteIntel
  ];
  stylix.fonts.sizes = {
    desktop = 12;
    applications = 14;
    terminal = 14;
    popups = 12;
  };
  programs.go-hass-agent = {
    commands = {
      button = [
        {
          name = "Switch to simrig";
          exec = "${toggleSimrig}/bin/toggle-simrig simrig";
        }
        {
          name = "Switch to desktop";
          exec = "${toggleSimrig}/bin/toggle-simrig desktop";
        }
      ];
    };
  };
  services.dunst.settings.global.monitor = "${monitors.top}";

  programs.hyprlock.settings = {
    general = {
      disable_loading_bar = true;
      grace = 0;
      hide_cursor = true;
      no_fade_in = false;
    };
    background = [
      {
        monitor = "${bottom_monitor}"; 
        path = "/home/azelphur/.wallpaper/bottom.png";
      }
      {
        monitor = "${top_monitor}"; 
        path = "/home/azelphur/.wallpaper/top.png";
      }
      {
        monitor = "${right_monitor}";
        path = "/home/azelphur/.wallpaper/right.png";
      }
      {
        monitor = "${left_monitor}";
        path = "/home/azelphur/.wallpaper/left.png";
      }
      {
        monitor = "${simrig_monitor}"; 
        path = "/home/azelphur/.wallpaper/simrig.png";
      }
    ];
    input-field = [{
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
    }
    {
        monitor = "${simrig_monitor}";
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
    }];
  };
} 
