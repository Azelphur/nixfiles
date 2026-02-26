{ config, pkgs, ... }:

let
  cecSend = pkgs.writeShellScriptBin "cec-send" ''
    #!/usr/bin/env bash
    set -euo pipefail

    if [ "$#" -ne 1 ]; then
      echo "usage: cec-send <command>" >&2
      exit 1
    fi

    echo "$1" | ${pkgs.netcat}/bin/nc -U /home/azelphur/.cecdaemon.sock
  '';
in
{
  imports = [
    ../common/flex-launcher/flex-launcher.nix
    ../common/retroarch/retroarch.nix
    ../common/kdeconnect.nix
    #./kodi/kodi.nix
    ../common/vacuum-tube.nix
  ];
  nixpkgs.config.allowUnfree = true;
  home.packages = [
    cecSend
  ];

  programs.plasma = {
    enable = true;
    # Don't start desktop applications that were open on previous boot
    session.sessionRestore.restoreOpenApplicationsOnLogin = "startWithEmptySession";

    powerdevil = {
      # Don't suspend when inactive (we have no way of waking back up)
      AC.autoSuspend.action = "nothing";
      AC.autoSuspend.idleTimeout = null;
      # Dim the display after 5 minutes
      AC.dimDisplay.enable = true;
      AC.dimDisplay.idleTimeout = 300;
      # Turn off the display after 10 minutes
      AC.turnOffDisplay.idleTimeout = 600;
      AC.powerProfile = "performance";
    };

    hotkeys.commands = {
      cec-volume-down = {
        name = "CEC Volume Down";
        key = "Volume Down";
        command = "cec-send volume_down";
      };
      cec-volume-up = {
        name = "CEC Volume Up";
        key = "Volume Up";
        command = "cec-send volume_up";
      };
      cec-volume-mute = {
        name = "CEC Volume Mute";
        key = "Volume Mute";
        command = "cec-send toggle_mute";
      };
    };
    shortcuts = {
      #"services/plasma-manager-commands.desktop".cec-volume-down = [ "Volume Down" ];
      #"services/plasma-manager-commands.desktop".cec-volume-mute = [ "Volume Mute" ];
      #"services/plasma-manager-commands.desktop".cec-volume-up = [ "Volume Up" ];
      # Disable the sleep button (we have no way of waking back up)
      "org_kde_powerdevil".Sleep = [ ];
      "kwin"."Window Close" = ["Alt+F4" "Home Page"];
    };

    kscreenlocker = {
      autoLock = false;
      timeout = 1;
      lockOnResume = false;
      lockOnStartup = false;
      passwordRequired = false;
      appearance.wallpaper = "/home/azelphur/.wallpaper.png";
    };

    workspace = {
      clickItemTo = "open"; # If you liked the click-to-open default from plasma 5
      lookAndFeel = "org.kde.breezedark.desktop";
      theme = "BreezeDark";
      iconTheme = "breeze-dark";
      wallpaper = "/home/azelphur/.wallpaper.png";
    };

    panels = [
      {
        location = "bottom";
        height = 48;
        #hiding = "autohide";
        widgets = [
          "org.kde.plasma.kickoff"
          {
            iconTasks = {
              launchers = [
                "applications:org.kde.dolphin.desktop"
                "applications:org.kde.konsole.desktop"
                "applications:firefox.desktop"
              ];
            };
          }
          "org.kde.plasma.systemtray"
          "org.kde.plasma.digitalclock"
        ];
      }
    ];
  };
}
