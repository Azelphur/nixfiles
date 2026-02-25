# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, inputs, lib, ... }:

{
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];
  #boot.kernel.sysctl = { "vm.swappiness" = 0;};
  #swapDevices = [{
  #  device = "/swapfile";
  #  size = 1024; # 1GB
  #}];
  # NixOS wants to enable GRUB by default
  #boot.loader.grub.enable = false;
  # Enables the generation of /boot/extlinux/extlinux.conf
  #boot.loader.generic-extlinux-compatible.enable = true;
  environment.systemPackages = with pkgs; [
    v4l-utils
  ];
  services.go2rtc = {
    enable = true;
    settings = {
      api.listen = "0.0.0.0:1984";
      streams = {
        camera = "ffmpeg:device?video=/dev/v4l/by-id/usb-Arducam_Technology_Co.__Ltd._USB_Camera_SN0001-video-index0&input_format=yuyv422&video_size=1920x1080#video=h264#hardware";
      };
    };
  };
  #services.mjpg-streamer = {
  #  enable = true;
  #  inputPlugin = "input_uvc.so -d /dev/v4l/by-id/usb-Arducam_Technology_Co.__Ltd._USB_Camera_SN0001-video-index0 -r 1280x720";
  #};
  networking.hostName = "snake-cam";
}
