{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs-2505.url = "github:NixOS/nixpkgs/nixos-25.05";
    nixpkgs-2511.url = "github:nixos/nixpkgs/nixos-25.11";
    nixos-raspberrypi = {
      url = "github:nvmd/nixos-raspberrypi/main";
      inputs.nixpkgs.follows = "nixpkgs-2505";
    };
    home-manager = {
      url = "github:nix-community/home-manager/";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };
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
      #url = "github:nix-community/stylix/pull/2337/head";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    matugen = {
      url = "github:InioX/Matugen";
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
    #opendeck-nix.url = "github:Kitt3120/opendeck-nix";
    opendeck-nix.url = "path:/home/azelphur/Downloads/opendeck-nix";
    opendeck-nix.inputs.nixpkgs.follows = "nixpkgs";
    partydeck = {
      url = "github:cseelhoff/partydeck";
      inputs.nixpkgs.follows = "nixpkgs-2511";
    };
    dms = {
      url = "github:AvengeMedia/DankMaterialShell/stable";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dms-plugins = {
      url = "git+https://github.com/AvengeMedia/dms-plugins";
      flake = false;
    };
    dms-plugins-taylan = {
      url = "git+https://github.com/TaylanTatli/dms-plugins";
      flake = false;
    };
    dms-plugin-hass = {
      url = "git+https://github.com/xxyangyoulin/dms-plugin-hass";
      flake = false;
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
            name = "nixos/cmk-agent: init module, cmk-agent: init at 2.3.0";
            url = "https://github.com/NixOS/nixpkgs/pull/399463.diff";
            hash = "sha256-jfTIzBu0KfDeCN5I9EOZ4zRhxdMOJQ1ALg/etLNocH4=";
          })
          (patcher.fetchpatch {
            name = "orca-slicer: fix missing preview";
            url = "https://github.com/NixOS/nixpkgs/pull/531346.diff";
            hash = "sha256-A+BlbpNobzvj+SEbCN5pErfMnEncDLcGUW5XNFKDpuY=";
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
        inputs.stylix.nixosModules.stylix
      ];
      serverModules = baseModules ++ [
        ./modules/nixos/common/linux-lts.nix
      ];
      htpcModules = baseModules ++ [
        ./modules/nixos/roles/desktop.nix
        ./modules/nixos/common/linux-latest.nix
        ./modules/nixos/roles/htpc.nix
      ];
      desktopModules = baseModules ++ [
        ./modules/nixos/common/linux-latest.nix
        ./modules/nixos/roles/desktop.nix
        ./modules/nixos/roles/pc.nix
      ];
      inherit (inputs)
        nixpkgs
        nixos-raspberrypi
        partydeck;
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
    nixosConfigurations.green-bedroom-mini-pc = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = htpcModules ++ [
        ./hosts/green-bedroom-mini-pc/configuration.nix
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
        inputs.opendeck-nix.nixosModules.default
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
      modules = [
        ./hosts/snake-cam/configuration.nix
        ./modules/nixos/roles/default.nix
        ./modules/nixos/common/home-manager.nix
        inputs.sops-nix.nixosModules.sops
        inputs.lanzaboote.nixosModules.lanzaboote
        inputs.nix-index-database.nixosModules.default
      ];
    };
    nixosConfigurations.printer-cam = nixos-raspberrypi.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        ({...}: {
          imports = with nixos-raspberrypi.nixosModules; [
            raspberry-pi-5.base
            raspberry-pi-5.bluetooth
          ];
        })
        ./hosts/printer-cam/configuration.nix
        ./modules/nixos/roles/default.nix
        #./modules/nixos/common/home-manager.nix
        inputs.sops-nix.nixosModules.sops
        inputs.lanzaboote.nixosModules.lanzaboote
        inputs.nix-index-database.nixosModules.default
      ];
    };
  };
}
