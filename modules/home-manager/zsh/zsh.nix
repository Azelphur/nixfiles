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
      b = "cd /etc/nixos && sudo nix flake update && sudo nixos-rebuild switch --upgrade --show-trace && sudo nix-env --delete-generations +5";
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
      if [ -z "''${WAYLAND_DISPLAY}" ] \
          && [ "''${XDG_VTNR}" -eq 1 ] \
          && uwsm check may-start; then
        if [ "''$(hostname)" = "azelphur-pc" ]; then
          TARGET_MONITORS=5
          echo "Waiting until $TARGET_MONITORS monitors are connected..."
          echo "Press any key to continue without waiting."

          while true; do
              # Count connected monitors
              connected_count=$(grep '^connected$' /sys/class/drm/*/status 2>/dev/null | wc -l)

              echo -ne "\r$connected_count/$TARGET_MONITORS monitors connected..."

              # Break if enough monitors are connected
              if [ "$connected_count" -ge "$TARGET_MONITORS" ]; then
                  echo -e "\nTarget number of monitors connected!"
                  break
              fi

              # Non-blocking keypress detection
              if read -t 1 -n 1 key; then
                  echo -e "\nUser pressed a key, continuing without all monitors."
                  break
              fi
          done
        fi
        exec uwsm start hyprland-uwsm.desktop
      fi
    '';
  };
}
