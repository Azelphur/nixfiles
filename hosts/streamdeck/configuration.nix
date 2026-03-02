# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, lib, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];
  boot.kernel.sysctl = { "vm.swappiness" = 0;};
  swapDevices = [{
    device = "/swapfile";
    size = 1024; # 1GB
  }];
  # NixOS wants to enable GRUB by default
  boot.loader.grub.enable = false;
  # Enables the generation of /boot/extlinux/extlinux.conf
  boot.loader.generic-extlinux-compatible.enable = true;
  networking.hostName = "streamdeck";

  services.cage = {
    enable = true;
    program = "${pkgs.streamcontroller}/bin/streamcontroller";
    user = config.my.user.name;
  };

  # wait for network and DNS
  systemd.services."cage-tty1".after = [
    "network-online.target"
    "systemd-resolved.service"
  ];
# Force it to start at boot
systemd.services."cage-tty1" = {
  wantedBy = [ "multi-user.target" ];
};

  environment.systemPackages = [ 
    pkgs.streamcontroller 
  ];
}
