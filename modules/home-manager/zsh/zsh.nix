{ config, pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    history = {
      extended = true;
      save = 99999999;
      size = 99999999;
    };
    shellAliases = {
      dc = "docker compose";
      d = "docker";
      dl = "docker logs --tail 1000 --follow";
      de = "docker exec -it";
      hl = "heroku logs --tail -a";
      hr = "heroku run -a";
      random = "openssl rand -hex 12";
    };
    autosuggestion = {
      enable = true;
    };
    oh-my-zsh = {
      enable = true;
      theme = "fox";
    };
    initExtra = "fastfetch --logo .assets/nixos.png --logo-type kitty-direct --logo-width 40 --logo-height 20";
  };
}
