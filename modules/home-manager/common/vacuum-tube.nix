{ config, pkgs, inputs, ... }:

{
  home.file = {
    ".config/VacuumTube/config.json".text = 
    builtins.toJSON {
      fullscreen = true;
      adblock = true;
      sponsorblock = true;
      sponsorblock_uuid = "a7213962-81a8-48b5-aead-90004fc350a8";
      dearrow = true;
      dislikes = true;
      remove_super_resolution = true;
      hide_shorts = false;
      h264ify = false;
      hardware_decoding = true;
      low_memory_mode = false;
      keep_on_top = false;
      userstyles = false;
      controller_support = true;
      wayland_hdr = true;
    };
  };
}
