{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    python312Packages.pygments
    fzf
    thefuck
  ];
  programs.zsh = {
    enable = true;
    history = {
      extended = true;
      save = 99999999;
      size = 99999999;
    };
    shellAliases = {
      dc = "docker compose";
      dcu = "docker compose up -d --remove-orphans";
      d = "docker";
      dl = "docker logs --tail 1000 --follow";
      de = "docker exec -it";
      hl = "heroku logs --tail -a";
      hr = "heroku run -a";
      random = "openssl rand -hex 12";
      b = "cd /etc/nixos && sudo nix flake update && sudo nixos-rebuild switch --upgrade && sudo nix-env --delete-generations 7d";
      grimblast = "grimblast-wrapper";
      ut = "./.ut";
    };
    enableCompletion = true;
    autosuggestion = {
      enable = true;
    };
    syntaxHighlighting = {
      enable = true;
    };
    oh-my-zsh = {
      enable = true;
      theme = "fox";
      plugins = ["colorize" "thefuck" "colored-man-pages" "copypath" "cp" "docker" "extract" "fzf" "heroku" "sudo" "git" "zsh-interactive-cd"];
    };
    initExtra = "fastfetch --logo .assets/nixos.png --logo-type kitty-direct --logo-width 40 --logo-height 20";
  };
}
