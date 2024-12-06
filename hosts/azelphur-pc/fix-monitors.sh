#!/usr/bin/env bash

hyprctl keyword monitor DP-1, 5120x1440@120, 1619x1440, 1, transform, 0, bitdepth, 10 # Bottom
hyprctl keyword monitor DP-2, 5120x1440@120, 1619x0, 1, transform, 2, bitdepth, 10 # Top
hyprctl keyword monitor DP-3, 3840x2160@60, 6739x0, 1.333333, transform, 3 # Right
hyprctl keyword monitor HDMI-A-1, 3840x2160@60, 0x0, 1.333333, transform, 1 # Left
systemctl --user restart hyprpaper
