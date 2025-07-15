#!/usr/bin/env bash
# This seems to make my monitors work more reliably. No idea why. Yay bugs.

# Disable all monitors apart from one, run it at 1080p
hyprctl keyword monitor DP-1, 1920x1080@60
hyprctl keyword monitor DP-2, disable
hyprctl keyword monitor DP-3, disable
hyprctl keyword monitor HDMI-A-1, disable

# Enable all the other monitors, only at 1080p
hyprctl keyword monitor DP-2, 1920x1080@60
hyprctl keyword monitor DP-3, 1920x1080@60
hyprctl keyword monitor HDMI-A-1, 1920x1080@60

# Now step them all up to maximum resolution / refresh rate
hyprctl keyword monitor DP-1, 5120x1440@120, 1619x1440, 1, transform, 0, bitdepth, 10 # Bottom
hyprctl keyword monitor DP-2, 5120x1440@120, 1619x0, 1, transform, 2, bitdepth, 10 # Top
hyprctl keyword monitor DP-3, 3840x2160@60, 6739x0, 1.333333, transform, 3 # Right
hyprctl keyword monitor HDMI-A-1, 3840x2160@60, 0x0, 1.333333, transform, 1 # Left

# This whole procedure freaks hyprpaper out, restart it.
systemctl --user restart hyprpaper

if [ "$1" = "lock" ]; then
  loginctl lock-session
fi
