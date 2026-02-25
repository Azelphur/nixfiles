# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, lib, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];
  boot.kernel.sysctl = { "vm.swappiness" = 0;};
  swapDevices = [{
    device = "/swapfile";
    size = 1024; # 1GB
  }];
  # NixOS wants to enable GRUB by default
  boot.loader.grub.enable = false;
  # Enables the generation of /boot/extlinux/extlinux.conf
  boot.loader.generic-extlinux-compatible.enable = true;
  environment.systemPackages = with pkgs; [
    v4l-utils
  ];
  services.go2rtc = {
    enable = true;
    settings = {
      api.listen = "0.0.0.0:1984";
      ffmpeg = {
        global = "-hide_banner";
        h264 = "-c:v libx264 -preset superfast -tune zerolatency -g 30 -bf 0 -pix_fmt yuv420p";
      };
      streams = {
        camera = "ffmpeg:device?video=/dev/v4l/by-id/usb-Arducam_Technology_Co.__Ltd._USB_Camera_SN0001-video-index0&input_format=yuyv422&video_size=1920x1080#video=h264#hardware#drawtext=x=10:y=10:fontsize=30:fontcolor=white:box=1:boxcolor=black";
      };
    };
  };
  networking.hostName = "snake-cam";
}
