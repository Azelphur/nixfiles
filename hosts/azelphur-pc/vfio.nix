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
        #"nvidia"
        #"nvidia_modeset"
        #"nvidia_uvm"
        #"nvidia_drm"
      ];

      kernelParams = [
        # enable IOMMU
        "amd_iommu=on"
      ] ++ lib.optional cfg.enable # Remove the semicolon here when uncommenting
        # isolate the GPU
        ("vfio-pci.ids=" + lib.concatStringsSep "," gpuIDs);
    };
    environment.systemPackages = [
      pkgs.evsieve
      (pkgs.writeShellScriptBin "toggle-source" ''
        ssh azelphur@10.0.1.17 ./toggle-source.sh
      '')
    ];
    #hardware.opengl.enable = true;
    hardware.graphics.enable = true;
    virtualisation = {
      spiceUSBRedirection.enable = true;
      libvirtd = {
        enable = true;
        #hooks.qemu = {
        #  gpu_binding = pkgs.writeShellScript "hook" ''
        #    command=$2
        #    gpu="0000:0d:00.0"
        #    aud="0000:0d:00.1"
        #    gpu_vd="$(cat /sys/bus/pci/devices/$gpu/vendor) $(cat /sys/bus/pci/devices/$gpu/device)"
        #    aud_vd="$(cat /sys/bus/pci/devices/$aud/vendor) $(cat /sys/bus/pci/devices/$aud/device)"
       # 
       #     function bind_vfio {
       #       modprobe -r nvidia-drm
       #       echo "$gpu" > "/sys/bus/pci/devices/$gpu/driver/unbind"
       #       echo "$aud" > "/sys/bus/pci/devices/$aud/driver/unbind"
       #       echo "$gpu_vd" > /sys/bus/pci/drivers/vfio-pci/new_id || true
       #       echo "$aud_vd" > /sys/bus/pci/drivers/vfio-pci/new_id || true
       #     }
       #     
       #     function unbind_vfio {
       #       echo "$gpu_vd" > "/sys/bus/pci/drivers/vfio-pci/remove_id"
       #       echo "$aud_vd" > "/sys/bus/pci/drivers/vfio-pci/remove_id"
       #       echo 1 > "/sys/bus/pci/devices/$gpu/remove"
       #       echo 1 > "/sys/bus/pci/devices/$aud/remove"
       #       echo 1 > "/sys/bus/pci/rescan"
       #     }
       # 
       #     if [ "$command" = "started" ]; then
      #        echo "Trying to take" > /tmp/status
      #        bind_vfio
      #      elif [ "$command" = "release" ]; then
      #        echo "Trying to unbind" > /tmp/status
      #        unbind_vfio
      #      fi
      #    '';
      #  };
      };
    };
    programs.virt-manager.enable = true;
    users.users.azelphur.extraGroups = [ "libvirtd" ];
  };
}
