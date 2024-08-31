{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    base16-schemes
  ];
  stylix.opacity.desktop = 0.6;
  stylix.targets.nixvim.enable = true;
}
