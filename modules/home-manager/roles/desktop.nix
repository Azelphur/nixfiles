{ config, pkgs, ... }:

{ 
  imports = [
    ../common/firefox.nix
    ../common/go-hass-agent/go-hass-agent.nix
  ];
}
