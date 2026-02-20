{ inputs, ... }:

{
  imports = [
    inputs.home-manager.nixosModules.default
  ];

  home-manager = {
    extraSpecialArgs = { inherit inputs; };

    users.azelphur.imports = [
      ../../home-manager/roles/default.nix
    ];

    useUserPackages = true;
  };
}
