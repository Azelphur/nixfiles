{ pkgs, ... }:

let
  retroarch-launcher = pkgs.writeShellScriptBin "retroarch-launcher" ''
    #!/usr/bin/env bash
    if [ -n "''${SteamAppUser}" ]; then 
        mkdir -p "/home/azelphur/.config/retroarch/saves/$SteamAppUser"
        mkdir -p "/home/azelphur/.config/retroarch/states/$SteamAppUser"
        echo "
        savefile_directory = /home/azelphur/.config/retroarch/saves/$SteamAppUser
        savestate_directory = /home/azelphur/.config/retroarch/states/$SteamAppUser
        " > /tmp/retroarch-append.cfg
    
        ARGS="--appendconfig /tmp/retroarch-append.cfg"
    fi

    retroarch $ARGS "$@"
  '';
in
{
  home.file = {
    ".config/retroarch/retroarch.cfg".source = ./retroarch.cfg;
  };
  home.packages = [
    retroarch-launcher
  ];
}
