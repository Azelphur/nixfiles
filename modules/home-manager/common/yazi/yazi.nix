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
    plugins = { inherit (pkgs.yaziPlugins)
      smart-enter
      mediainfo;
    };
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
    keymap = {
      mgr.prepend_keymap = [
        {
          on = [ "<Enter>" ];
          run = "plugin smart-enter";
          desc = "Smart enter";
        }
      ];
    };
  };
  xdg.configFile."xdg-desktop-portal/portals.conf".text = ''
    [preferred]
    org.freedesktop.impl.portal.FileChooser=termfilechooser
  '';
  xdg.configFile."xdg-desktop-portal-termfilechooser/config" =
  {
    force = true;
    text =
    ''
      [filechooser]
      cmd=${pkgs.xdg-desktop-portal-termfilechooser}/share/xdg-desktop-portal-termfilechooser/yazi-wrapper.sh
      default_dir=$HOME
      env=TERMCMD=${pkgs.kitty}/bin/kitty
    '';
  };

  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory" = ["yazi.desktop"];
      "application/zip" = ["yazi.desktop"];
    };
  };
  xdg.portal = {
    enable = true;
    config.common.default = "*";
    extraPortals = [
      pkgs.xdg-desktop-portal-termfilechooser
    ];
  };
}
