{ config, pkgs, lib, ... }:

{
  home.sessionVariables.TERMCMD = "kitty --class=file_chooser";
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
    extraPackages = with pkgs; [
      mediainfo
      imagemagick
    ];
    plugins = { inherit (pkgs.yaziPlugins) mediainfo; };
    settings = {
      opener = {
        open = [
          {
            run = "xdg-open \"$@\"";
            desc = "Open";
            orphan = true;
          }
        ];
      };
      plugin = {
        prepend_preloaders = [
          { mime = "{audio,video,image}/*"; run = "mediainfo"; }
          { mime = "application/subrip"; run = "mediainfo"; }
        ];
        prepend_previewers = [
          { mime = "{audio,video,image}/*"; run = "mediainfo"; }
          { mime = "application/subrip"; run = "mediainfo"; }
        ];
      };
      tasks.image_alloc = 1073741824;
    };
  };

  xdg.configFile."xdg-desktop-portal-termfilechooser/config" =
  {
    force = true;
    text =
    ''
      [filechooser]
      cmd=${pkgs.xdg-desktop-portal-termfilechooser}/share/xdg-desktop-portal-termfilechooser/yazi-wrapper.sh
    '';
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory" = ["yazi.desktop"];
      "application/zip" = ["yazi.desktop"];
    };
  };
}
