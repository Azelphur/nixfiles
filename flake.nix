{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    #hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    # where {version} is the hyprland release version
    # or "github:hyprwm/Hyprland?submodules=1" to follow the development branch

    #hy3 = {
    #url = "github:outfoxxed/hy3"; # where {version} is the hyprland release version
      # or "github:outfoxxed/hy3" to follow the development branch.
      # (you may encounter issues if you dont do the same for hyprland)
    #  inputs.hyprland.follows = "hyprland";
    #};

    nixvim = {
      url = "github:nix-community/nixvim";
      # If you are not running an unstable channel of nixpkgs, select the corresponding branch of nixvim.
      # url = "github:nix-community/nixvim/nixos-24.05";

      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix.url = "github:danth/stylix";
  };

  outputs = { self, nixpkgs, nixvim, home-manager, ... }@inputs: {
    nixosConfigurations.azelphur-pc = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        ./hosts/azelphur-pc/configuration.nix
        inputs.home-manager.nixosModules.default
        inputs.stylix.nixosModules.stylix
      ];
    };
#    homeConfigurations."azelphur@azelphur-pc" = home-manager.lib.homeManagerConfiguration {
#      pkgs = nixpkgs.legacyPackages.x86_64-linux;
#
#      modules = [
#        hyprland.homeManagerModules.default
#
#        {
#          wayland.windowManager.hyprland = {
#            plugins = [ hy3.packages.x86_64-linux.hy3 ];
#          };
#        }
#      ];
#    };
    nixosConfigurations.azelphur-framework = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        ./hosts/azelphur-framework/configuration.nix
        inputs.home-manager.nixosModules.default
        inputs.stylix.nixosModules.stylix
      ];
    };
  };
}
