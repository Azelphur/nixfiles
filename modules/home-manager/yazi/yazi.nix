{ config, pkgs, ... }:

{
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;
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
    };
  };
  xdg.mimeApps = {
    enable = true;
    defaultApplications = {
      "inode/directory" = ["yazi.desktop"];
      "application/zip" = ["yazi.desktop"];
    };
  };
}
