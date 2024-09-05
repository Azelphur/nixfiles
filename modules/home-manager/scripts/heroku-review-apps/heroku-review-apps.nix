{ config, pkgs, ... }:

{
  xdg.desktopEntries = {
    heroku-fuzzel = {
      name = "Heroku Review Apps";
      genericName = "Heroku Review Apps";
      exec = "${pkgs.writeScriptBin "heroku-review-apps.py" (builtins.readFile ./heroku-review-apps.py)}/bin/heroku-review-apps.py";
      terminal = false;
      categories = [ "Application" ];
      icon = ./heroku.png;
    };
  };
  home.file = {
    ".bin/assets/heroku.png".source = ./heroku.png;
  };
}
