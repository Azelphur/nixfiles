{ pkgs, ... }:

let
  ryujinx-launcher = pkgs.writeShellScriptBin "ryujinx-launcher" ''
    #!/usr/bin/env bash
    if [ -n "''${SteamAppUser}" ]; then 
        ARGS="--profile ''$SteamAppUser"
    fi

    ryujinx $ARGS "$@"
  '';
in
{
  home.packages = [
    ryujinx-launcher
  ];
  home.file = {
    "ES-DE/custom_systems/es_systems.xml".source = ./es_systems.xml;
    "ES-DE/settings/es_settings.xml".source = ./es_settings.xml;
    "ES-DE/custom_systems/es_find_rules.xml" = {
      text = ''
        <?xml version="1.0"?>
        <!-- This is the ES-DE find rules configuration file for Linux -->
        <ruleList>
          <core name="RETROARCH">
            <rule type="corepath">
              <!-- NixOS -->
              <entry>${pkgs.retroarch-full}/lib/retroarch/cores/</entry>
            </rule>
          </core>
        </ruleList>
      '';
    };
  };
}
