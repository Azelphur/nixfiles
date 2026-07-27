{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    rocmPackages.rocm-smi
  ];
  programs.btop = {
    enable = true;
    package = pkgs.btop-rocm;
  };
}
