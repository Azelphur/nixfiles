{ pkgs, config, ... }:

let
  flydigi-vader5 = pkgs.callPackage ../../../pkgs/flydigi-vader5/flydigi-vader5.nix {};
in
{
  environment.systemPackages = [
    flydigi-vader5
  ];
  services.udev.extraRules = ''
    # Flydigi Vader 5 Pro - allow non-root access to hidraw
    KERNEL=="hidraw*", ATTRS{idVendor}=="37d7", ATTRS{idProduct}=="2401", MODE="0666", TAG+="uaccess"

    # Flydigi DInput mode (if applicable)
    KERNEL=="hidraw*", ATTRS{idVendor}=="04b4", MODE="0666", TAG+="uaccess"
  '';
  systemd.user.services.vader5d = {
    description = "vader5d";
    wantedBy = [ "default.target" ];
    serviceConfig = {
      ExecStart = "${flydigi-vader5}/bin/vader5d -c /etc/flydigi-vader5.toml";
      Restart = "always";
    };
  };
}
