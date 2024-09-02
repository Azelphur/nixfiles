{ config, pkgs, lib, ... }:

{
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        font = lib.mkForce "DejaVu Sans:size=25";
	lines = 8;
	line-height = 60;
      };
    };
  };
}
