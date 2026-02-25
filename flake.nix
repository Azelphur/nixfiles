{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
    jovian-nixos.url = "github:jovian-experiments/jovian-nixos";
    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    flake-input-patcher.url = "github:jfly/flake-input-patcher";
    nixvim = {
      url = "github:nix-community/nixvim";
    };
    nixcord = {
      url = "github:kaylorben/nixcord";
    };
    stylix = {
      url = "github:danth/stylix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    spicetify-nix = {
      url = "github:Gerg-L/spicetify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = unpatchedInputs:
      let
      # Unfortunately, this utility requires hardcoding a single system. See
      # "Known issues" below.
      patcher = unpatchedInputs.flake-input-patcher.lib.x86_64-linux;

      inputs = patcher.patch unpatchedInputs {
        # Patching a direct dependency:
        nixpkgs.patches = [
          (patcher.fetchpatch {
            name = "python3Packages.cec: init at 0.2.8, cecdaemon: init at 1.0.0-unstable-2025-11-12";
            url = "https://github.com/NixOS/nixpkgs/pull/464399.diff";
            hash = "sha256-Xuhx1R8OvMR+KPNAMrJ5MzZFHntO37EfaRjw7jt6l4k=";
          })
          (patcher.fetchpatch {
            name = "nixos/cmk-agent: init module, cmk-agent: init at 2.3.0";
            url = "https://github.com/NixOS/nixpkgs/pull/399463.diff";
            hash = "sha256-3vMQdfBGMt2oHMiB3nuesoyWtR9uk8+HhVZm4jUnPE0=";
          })
        ];

        # Patching a transitive dependency:
        clan-core.inputs.data-mesher.patches = [
           # ... More patches here ...
        ];
      };
      
      baseModules = [
        ./modules/nixos/roles/default.nix
        ./modules/nixos/common/systemd-boot.nix
        ./modules/nixos/common/home-manager.nix
        inputs.sops-nix.nixosModules.sops
        inputs.lanzaboote.nixosModules.lanzaboote
        inputs.nix-index-database.nixosModules.default
      ];
      serverModules = baseModules ++ [
        ./modules/nixos/common/linux-lts.nix
      ];
      pcModules = baseModules ++ [
        ./modules/nixos/common/linux-latest.nix
      ];
      htpcModules = baseModules ++ [
        inputs.jovian-nixos.nixosModules.default
        ./modules/nixos/roles/desktop.nix
        ./modules/nixos/roles/htpc.nix
      ];
      desktopModules = baseModules ++ [
        ./modules/nixos/roles/desktop.nix
        ./modules/nixos/roles/pc.nix
        inputs.stylix.nixosModules.stylix
      ];
      inherit (inputs)
        nixpkgs;
    in
    {
    nixosConfigurations.master-bedroom-mini-pc = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = htpcModules ++ [
        ./hosts/master-bedroom-mini-pc/configuration.nix
      ];
    };
    nixosConfigurations.living-room-mini-pc = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = htpcModules ++ [
        ./hosts/living-room-mini-pc/configuration.nix
      ];
    };
    nixosConfigurations.azelphur-framework = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = desktopModules ++ [
        ./hosts/azelphur-framework/configuration.nix
      ];
    };
    nixosConfigurations.azelphur-pc = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = desktopModules ++ [
        ./hosts/azelphur-pc/configuration.nix
      ];
    };
    nixosConfigurations.azelphur-backup = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = serverModules ++ [
        ./hosts/azelphur-backup/configuration.nix
      ];
    };
    nixosConfigurations.azelphur-server = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = serverModules ++ [
        ./hosts/azelphur-server/configuration.nix
        ./modules/nixos/common/docker.nix
      ];
    };
    nixosConfigurations.snake-cam = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = serverModules ++ [
        ./hosts/snake-cam/configuration.nix
      ];
    };
    # I will leave this here, just in case future self wants an example
    # Of how to set up a raspberry pi
    #nixosConfigurations.snake-cam = nixpkgs.lib.nixosSystem {
    #  specialArgs = {inherit inputs;};
    #  modules = [
    #    ./hosts/snake-cam/configuration.nix
    #    ./modules/nixos/roles/default.nix
    #    ./modules/nixos/common/home-manager.nix
    #    inputs.lanzaboote.nixosModules.lanzaboote
    #    inputs.nix-index-database.nixosModules.default
    #  ];
    #};
  };
}
