{ config, pkgs, inputs, ... }:

{ 
  imports = [
    ../common/nixvim.nix
    ../common/zsh.nix
    inputs.nixvim.homeModules.nixvim
    inputs.agenix.homeManagerModules.default
  ];

  programs.ssh = {
    enable = true;
    extraConfig = ''
      Host svr
      HostName azelphur-server.internal

      Host pc
      HostName azelphur-pc.internal

      Host fw
      HostName 10.0.4.4
      
      Host azelphur-framework
      HostName 10.0.4.4

      Host azelphur-backup
      HostName backup.azelphur.com
      Port 23
    '';
  };

  nixpkgs.config.allowUnfree = true;
  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.
}
