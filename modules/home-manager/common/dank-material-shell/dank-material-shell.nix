{ config, pkgs, inputs, sops-nix, ... }:

let
  settings =
    (builtins.removeAttrs
      (builtins.fromJSON (builtins.readFile ./settings.json))
      [ 
        "customThemeFile" 
        "dockTransparency"
        "popupTransparency"
      ])
    // {
      gtkThemingEnabled = true;
      iconTheme = "Adwaita";
      qtThemingEnabled = false;
    };
in
{
  home.packages = with pkgs; [
    # Needed for the Home Assistant Monitor plugin's websocket connection.
    qt6.qtwebsockets
  ];
  systemd.user.services.dms.Service = {
    Restart = "on-failure";
    RestartSec = "2s";
  };

  sops.defaultSopsFile = ../../../../secrets/secrets.yaml;
  sops.age.keyFile = "/var/lib/sops-nix/keys.txt";
  sops.secrets = {
    ha-token = {};
  };
  programs.dank-material-shell = {
    enable = true;
    inherit settings;
    systemd = {
      enable = true;
      restartIfChanged = true;
    };
    plugins = {
      dankKDEConnect.src = inputs.dms-plugins + "/DankKDEConnect";
      dankBatteryAlerts.src = inputs.dms-plugins + "/DankBatteryAlerts";
      grimblast.src = inputs.dms-plugins-taylan + "/grimblast";
      homeAssistantMonitor = {
        src = inputs.dms-plugin-hass;
        settings = {
          hassUrl = "https://homeassistant.home.azelphur.com";
          hassTokenPath = config.sops.secrets.ha-token.path;
          hassToken = "";
        };
      };
    };
  };
}
