# Edit this configuration file to define what should be installed on
# your system. Help is available in the configuration.nix(5) man page, on
# https://search.nixos.org/options and in the NixOS manual (`nixos-help`).

{ config, lib, pkgs, inputs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules/nixos/hardware/amd.nix
    ../../modules/nixos/hardware/bluetooth.nix
  ];

  console = lib.mkForce {
    font = "Lat2-Terminus16";
    keyMap = "colemak";
  };

  systemd.services.NetworkManager-wait-online.enable = false;

  networking.hostName = "azelphur-framework"; # Define your hostname.

  # Enable touchpad support (enabled default in most desktopManager).
  services.libinput.enable = true;

  home-manager.users.${config.my.user.name}.imports = [
    ./home.nix
  ];
}

