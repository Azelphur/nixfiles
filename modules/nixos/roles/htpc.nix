{ config, lib, pkgs, inputs, ...}:

{
  imports = [
  ];
  services.desktopManager.plasma6.enable = true;

  environment.etc."wallpaper.png".source = ../../../assets/htpc-background.png;

  jovian.steam.enable = true;
  jovian.steam.autoStart = true;
  jovian.steam.user = "azelphur";
  jovian.steam.desktopSession = "plasma";

  environment.systemPackages = with pkgs; [
    vacuum-tube
    flex-launcher
    snapcast
  ];

  systemd.user.services.snapclient = {
    wantedBy = [
      "pipewire.service"
    ];
    after = [
      "pipewire.service"
    ];
    serviceConfig = {
      ExecStart = "${pkgs.snapcast}/bin/snapclient";
    };
  };

  systemd.services.cecdaemon =
    let
      cecConf = {
        tv.name = "HTPC";
        keymap = { 
          "0" = "KEY_ENTER";
          "1" = "KEY_UP";
          "2" = "KEY_DOWN";
          "3" = "KEY_LEFT";
          "4" = "KEY_RIGHT";
          "9" = "KEY_HOME";
          "11" = "KEY_INFO";
          "13" = "KEY_ESC";
          "17" = "KEY_TITLE";
          "64" = "KEY_POWER";
          "53" = "KEY_MENU";
          "68" = "KEY_PLAY";
          "69" = "KEY_STOP";
          "70" = "KEY_PAUSE";
          "75" = "KEY_FASTFORWARD";
          "76" = "KEY_REWIND";
          "113" = "KEY_BLUE";
          "114" = "KEY_RED";
          "115" = "KEY_GREEN";
          "116" = "KEY_YELLOW";
        };
      };
      settingsFormat = pkgs.formats.ini { };
      configFile = settingsFormat.generate "cec.conf" cecConf;
    in
    {
      after = [ "multi-user.target" ];
      wantedBy = [ "multi-user.target" ];
      enable = true;
      serviceConfig.ExecStart = "${lib.getExe pkgs.cecdaemon} --config=${configFile}";
    };

  home-manager.users.${config.my.user.name}.imports = [
    inputs.plasma-manager.homeModules.plasma-manager
    ../../home-manager/roles/htpc.nix
  ];
}
