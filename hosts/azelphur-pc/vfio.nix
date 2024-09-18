let
  # RTX 3080
  gpuIDs = [
    "10de:2206" # Graphics
    "10de:1aef" # Audio
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
        #"vfio_virqfd"

        "nvidia"
        "nvidia_modeset"
        "nvidia_uvm"
        "nvidia_drm"
      ];

      kernelParams = [
        # enable IOMMU
        "amd_iommu=on"
      ] ++ lib.optional cfg.enable
        # isolate the GPU
        ("vfio-pci.ids=" + lib.concatStringsSep "," gpuIDs);
    };
    environment.systemPackages = [
      pkgs.evsieve
      (pkgs.writeShellScriptBin "toggle-source" ''
        ssh azelphur@192.168.1.56 ./toggle-source.sh
      '')
    ];
    #hardware.opengl.enable = true;
    hardware.graphics.enable = true;
    virtualisation.spiceUSBRedirection.enable = true;
    virtualisation.libvirtd.enable = true;
    programs.virt-manager.enable = true;
    users.users.azelphur.extraGroups = [ "libvirtd" ];
  };
}
