let
  gpuIDs = [
    "1002:7550" # Graphics
    "1002:ab40" # Audio
  ];
in { pkgs, lib, config, ... }: {
  options.vfio.enable = with lib;
    mkEnableOption "Configure the machine for VFIO";

  config = let cfg = config.vfio;
  in {
    boot = {
      initrd.kernelModules = [
        "vfio_pci"
        "vfio"
        "vfio_iommu_type1"
      ];

      kernelParams = [
        # enable IOMMU
        "amd_iommu=on"
      ];
    };
    environment.systemPackages = [
      pkgs.evsieve
      (pkgs.writeShellScriptBin "toggle-source" ''
        ssh azelphur@10.0.1.17 ./toggle-source.sh
      '')
    ];
    hardware.graphics.enable = true;
    virtualisation = {
      spiceUSBRedirection.enable = true;
      libvirtd = {
        enable = true;
      };
    };
    programs.virt-manager.enable = true;
    users.users.azelphur.extraGroups = [ "libvirtd" ];
  };
}
