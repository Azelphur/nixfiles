{ config, pkgs, ... }:

{ 
  imports = [
    ../common/nixcord.nix
    ../common/hyprland/hyprland.nix
    ../common/kitty.nix
    ../common/spicetify.nix
    ../common/fuzzel/fuzzel.nix
    ../common/cliphist/cliphist.nix
    ../common/dunst/dunst.nix
    ../common/hyprlock/hyprlock.nix
    ../common/hypridle/hypridle.nix
    ../common/waybar/waybar.nix
    ../common/flameshot.nix
  ];

  stylix.targets.firefox.profileNames = ["default"];
  programs.thunderbird = {
    enable = true;
    profiles.default = {
      isDefault = true;
    };
  };
  # Nextcloud will prompt for password every boot without this
  services.gnome-keyring.enable = true;
  home.packages = with pkgs; [
     gcr
  ];
  services.nextcloud-client = {
    enable = true;
    startInBackground = true;
  };
}
