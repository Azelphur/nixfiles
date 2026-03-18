{ config, pkgs, inputs, ... }:


let
  crunchyroll-linux = import ../../../pkgs/crunchyroll-linux.nix {inherit pkgs;};
in {
  environment.systemPackages = with pkgs; [
    crunchyroll-linux
  ];
}
