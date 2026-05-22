{ config, pkgs, inputs, ...}:

{
  environment.systemPackages = with pkgs; [ 
    oversteer
    linuxConsoleTools
  ];
  services.udev.packages = [
    pkgs.oversteer
  ];
  hardware.hid-fanatecff.enable = true;
}
