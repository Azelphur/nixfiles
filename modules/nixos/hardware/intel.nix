{ config, pkgs, inputs, ...}:

{
  # Enable hardware acceleration for video
  hardware.graphics = {
    enable = true;
    extraPackages = with pkgs; [
      intel-media-driver
    ];
  };

  environment.sessionVariables = { LIBVA_DRIVER_NAME = "iHD"; };

  environment.systemPackages = with pkgs; [
    nvtopPackages.intel
  ];
}
