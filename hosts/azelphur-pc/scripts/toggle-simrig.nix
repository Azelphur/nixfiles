{ pkgs, monitors }:

pkgs.writeShellScriptBin "toggle-simrig" ''
  #!/usr/bin/env bash
  set -euo pipefail

  mode="''${1:-}"

  case "$mode" in
    desktop)
      hyprctl --instance 0 keyword monitor "${monitors.right},3840x2160@60,6740x0,1.333333,transform,3"
      hyprctl --instance 0 keyword monitor "${monitors.simrig},disable"
      hyprctl --instance 0 keyword monitor "${monitors.left},3840x2160@60,0x0,1.333333,transform,1"
      hyprctl --instance 0 keyword monitor "${monitors.top},5120x1440@240,1620x0,1,transform,2,bitdepth,10,cm,hdr,sdrbrightness,1.3,sdrsaturation,1.2"
      hyprctl --instance 0 keyword monitor "${monitors.bottom},5120x1440@240,1620x1440,1,transform,0,bitdepth,10,cm,hdr,sdrbrightness,1.3,sdrsaturation,1.2"
      ;;

    simrig)
      hyprctl --instance 0 keyword monitor "${monitors.left},disable"
      hyprctl --instance 0 keyword monitor "${monitors.top},disable"
      hyprctl --instance 0 keyword monitor "${monitors.bottom},disable"
      hyprctl --instance 0 keyword monitor "${monitors.simrig},3840x2160@60,0x0,1"
      hyprctl --instance 0 keyword monitor "${monitors.right},disable"
      ;;
  esac
''
