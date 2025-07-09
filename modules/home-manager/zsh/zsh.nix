{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    python312Packages.pygments
    fzf
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
      b = "cd /etc/nixos && sudo nix flake update && sudo nixos-rebuild switch --upgrade && sudo nix-env --delete-generations +5";
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
      plugins = ["colorize" "colored-man-pages" "copypath" "cp" "docker" "extract" "fzf" "heroku" "sudo" "git" "zsh-interactive-cd"];
    };
    initContent = ''
      fastfetch --logo-width 40 --logo-height 20
      if [ -z "''${WAYLAND_DISPLAY}" ] && [ "''${XDG_VTNR}" -eq 1 ] && uwsm check may-start; then
          exec uwsm start hyprland-uwsm.desktop
      fi
    '';
  };
}
