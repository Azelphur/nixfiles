{ config, pkgs, inputs, lib, monitors, ... }:

let
  toggleSimrig = import ./scripts/toggle-simrig.nix {
    inherit pkgs monitors;
  };
  monitors = import ./monitors.nix;
in
{
  imports = [
    ../../modules/home-manager/common/elite-dangerous/elite-dangerous.nix
  ];
  home.packages = with pkgs; [
    toggleSimrig
  ];
  stylix.fonts.sizes = {
    desktop = 12;
    applications = 14;
    terminal = 14;
    popups = 12;
  };
  systemd.user.services.opendeck = {
    Unit = {
      Description = "OpenDeck";
      After = [ "graphical-session.target" ];
      Wants = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };

    Service = {
      Type = "simple";
      ExecStart = "${inputs.opendeck-nix.packages.${pkgs.system}.default}/bin/opendeck --hide";

      Restart = "on-failure";
      RestartSec = 5;
    };

    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
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
  wayland.windowManager.hyprland = {
    extraConfig = ''
      require("workspaces")
      require("display_profiles")
      require("binds_azelphur_pc")
      display_profiles = require("display_profiles")
      display_profiles.desk()
    '';
    settings = {
      config = {
        input = {
          kb_layout = "gb";
        };
      };
      window_rule = [
        {
          name = "PIPWindow";
          match = {
            title = "PIPWindow";
          };
          float = true;
          move = "monitor_w-window_w-40 40";
          opacity = 1;
          pin = true;
          no_initial_focus = true;
          monitor = monitors.bottom;
        }
      ];
    };
  };


  xdg.configFile."hypr/binds_azelphur_pc.lua".source = ./hyprland/binds_azelphur_pc.lua;
  xdg.configFile."hypr/monitors.lua".source = ./hyprland/monitors.lua;
  xdg.configFile."hypr/display_profiles.lua".source = ./hyprland/display_profiles.lua;
  xdg.configFile."hypr/workspaces.lua".source = ./hyprland/workspaces.lua;

  programs.hyprlock.settings = {
    general = {
      disable_loading_bar = true;
      grace = 0;
      hide_cursor = true;
      no_fade_in = false;
    };
    background = [
      {
        monitor = "${monitors.bottom}"; 
        path = "/home/azelphur/.wallpaper/bottom.png";
      }
      {
        monitor = "${monitors.top}"; 
        path = "/home/azelphur/.wallpaper/top.png";
      }
      {
        monitor = "${monitors.right}";
        path = "/home/azelphur/.wallpaper/right.png";
      }
      {
        monitor = "${monitors.left}";
        path = "/home/azelphur/.wallpaper/left.png";
      }
      {
        monitor = "${monitors.simrig}"; 
        path = "/home/azelphur/.wallpaper/simrig.png";
      }
    ];
    input-field = [{
        monitor = "${monitors.bottom}";
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
        monitor = "${monitors.simrig}";
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
