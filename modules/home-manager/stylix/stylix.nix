{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    base16-schemes
  ];
  stylix.opacity.desktop = 0.6;
  stylix.targets.qt.enable = true;
  stylix.targets.nixvim.enable = true;
  stylix.fonts.sizes.applications = 15;
  stylix.fonts.sizes.desktop = 15;
  stylix.fonts.sizes.popups = 15;
  stylix.fonts.sizes.terminal = 15;
}
