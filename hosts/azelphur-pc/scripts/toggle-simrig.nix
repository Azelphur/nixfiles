{ pkgs, monitors }:

pkgs.writeShellScriptBin "toggle-simrig" ''
  #!/usr/bin/env bash
  set -euo pipefail

  mode="''${1:-}"

  case "$mode" in
    desktop)
      hyprctl --instance 0 eval 'require("display_profiles").desk();'
      ;;

    simrig)
      hyprctl --instance 0 eval 'require("display_profiles").simrig();'
      ;;
  esac
''
