# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ../../modules/nixos/common/check-mk-agent/check-mk-agent.nix
  ];
  networking.hostName = "azelphur-backup";
  environment.systemPackages = with pkgs; [
    pkgs.borgbackup
  ];
  users.users.${config.my.user.name}.openssh.authorizedKeys.keys = ["ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGXRvmL6wQ5gZB7/a/v6PDSXFOdWLO0MtkrMS0UVXoii azelphur@azelphur-server"];
}
