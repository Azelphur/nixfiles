{ config, pkgs, ... }:

let
  ww = pkgs.writeShellScriptBin "ww" (builtins.readFile ../common/ww/ww);
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
    ww
  ];

  xdg.desktopEntries.flex-launcher-ww = {
    name = "Flex Launcher (WW)";
    type = "Application";
    genericName = "Application Launcher";
    comment = "Customizable HTPC Application Launcher";
    exec = "${ww}/bin/ww -f flex-launcher -c flex-launcher";
    terminal = false;
    icon = "flex-launcher";
    categories = [ "Video" "AudioVideo" ];
  };

  services.mpdris2 = {
    notifications = true;
    enable = true;
    mpd.host = "127.0.0.1";
  };
  services.mpd = {
    enable = true;
    musicDirectory = "/home/azelphur/Music";
    # Optional:
    network.listenAddress = "any"; # if you want to allow non-localhost connections
    network.startWhenNeeded = true; # systemd feature: only start MPD service upon connection to its socket
  };

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
      "kwin"."Window Close" = ["Alt+F4" "Sleep"];
      "services/flex-launcher-ww.desktop"._launch = "Home Page";
      kwin.ExposeAll = ["Menu" "Ctrl+F10" "Launch (C)"];
    };
    configFile = {
      kwinrulesrc."28ac492a-765a-45d9-a61c-cdd0815ec315".Description = "PIPWindow";
      kwinrulesrc."28ac492a-765a-45d9-a61c-cdd0815ec315".above = true;
      kwinrulesrc."28ac492a-765a-45d9-a61c-cdd0815ec315".aboverule = 2;
      kwinrulesrc."28ac492a-765a-45d9-a61c-cdd0815ec315".layer = "osd";
      kwinrulesrc."28ac492a-765a-45d9-a61c-cdd0815ec315".layerrule = 2;
      kwinrulesrc."28ac492a-765a-45d9-a61c-cdd0815ec315".position = "1050,0";
      kwinrulesrc."28ac492a-765a-45d9-a61c-cdd0815ec315".positionrule = 2;
      kwinrulesrc."28ac492a-765a-45d9-a61c-cdd0815ec315".size = "870,700";
      kwinrulesrc."28ac492a-765a-45d9-a61c-cdd0815ec315".sizerule = 2;
      kwinrulesrc."28ac492a-765a-45d9-a61c-cdd0815ec315".skippager = true;
      kwinrulesrc."28ac492a-765a-45d9-a61c-cdd0815ec315".skippagerrule = 2;
      kwinrulesrc."28ac492a-765a-45d9-a61c-cdd0815ec315".skipswitcher = true;
      kwinrulesrc."28ac492a-765a-45d9-a61c-cdd0815ec315".skipswitcherrule = 2;
      kwinrulesrc."28ac492a-765a-45d9-a61c-cdd0815ec315".skiptaskbar = true;
      kwinrulesrc."28ac492a-765a-45d9-a61c-cdd0815ec315".skiptaskbarrule = 2;
      kwinrulesrc."28ac492a-765a-45d9-a61c-cdd0815ec315".title = "PIPWindow";
      kwinrulesrc."28ac492a-765a-45d9-a61c-cdd0815ec315".titlematch = 1;
      kwinrulesrc."28ac492a-765a-45d9-a61c-cdd0815ec315".wmclass = "electron electron";
      kwinrulesrc."28ac492a-765a-45d9-a61c-cdd0815ec315".wmclasscomplete = true;
      kwinrulesrc."28ac492a-765a-45d9-a61c-cdd0815ec315".wmclassmatch = 1;
      kwinrulesrc.General.rules = "28ac492a-765a-45d9-a61c-cdd0815ec315";
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
        hiding = "autohide";
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
