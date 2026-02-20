{ config, pkgs, inputs, ...}:

{
  # Enable hardware acceleration for video
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };
  environment.systemPackages = with pkgs; [
    nvtopPackages.amd
  ];
}
