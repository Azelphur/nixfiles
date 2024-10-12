{
  description = "Nixos config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    #nixpkgs.url = "path:///home/azelphur/Downloads/nixpkgs";

    #hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1&ref=v0.44.1";
    hyprland.url = "github:hyprwm/Hyprland?ref=v0.44.0";
    # where {version} is the hyprland release version
    # or "github:hyprwm/Hyprland?submodules=1" to follow the development branch

    hy3 = {
      url = "github:outfoxxed/hy3?ref=hl0.44.0"; # where {version} is the hyprland release version
      # or "github:outfoxxed/hy3" to follow the development branch.
      # (you may encounter issues if you dont do the same for hyprland)
      inputs.hyprland.follows = "hyprland";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      # If you are not running an unstable channel of nixpkgs, select the corresponding branch of nixvim.
      # url = "github:nix-community/nixvim/nixos-24.05";

      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.1";

      # Optional but recommended to limit the size of your system closure.
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixcord = {
      url = "github:kaylorben/nixcord";
    };

    stylix.url = "github:danth/stylix";
  };

  outputs = { self, nixpkgs, nixvim, hyprland, hy3, home-manager, ... }@inputs: {
    nixosConfigurations.azelphur-pc = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        inputs.lanzaboote.nixosModules.lanzaboote
        ./hosts/azelphur-pc/configuration.nix
        inputs.home-manager.nixosModules.default
        inputs.stylix.nixosModules.stylix
      ];
    };
    nixosConfigurations.azelphur-framework = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        inputs.lanzaboote.nixosModules.lanzaboote
        ./hosts/azelphur-framework/configuration.nix
        inputs.home-manager.nixosModules.default
        inputs.stylix.nixosModules.stylix
      ];
    };
  };
}
