{ config, pkgs, inputs, ... }:


{
  environment.systemPackages = with pkgs; [
    orca-slicer
  ];

  services.syncthing = {
    enable = true;
    user = "${config.my.user.name}";
    configDir = "/home/${config.my.user.name}/.config/syncthing";
    settings = {
      folders = {
        "Orca-slicer" = {
          path = "/home/${config.my.user.name}/.config/OrcaSlicer/";
          devices = ["azelphur-framework" "azelphur-pc"];
          versioning = {
            type = "simple";
            params.keep = "10";
          };
        };
      };
    };
  };
}
