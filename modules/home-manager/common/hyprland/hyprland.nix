{ configs, pkgs, inputs, config, ... }:

{
  home.packages = with pkgs; [
    playerctl
    pkgs.hyprpicker
    (pkgs.writeShellScriptBin "grimblast-wrapper" ''
      hyprctl clients -j | jq -r ".[].address" | xargs -I {} hyprctl setprop address:{} opaque on > /dev/null
      grimblast "$@"
      hyprctl clients -j | jq -r ".[].address" | xargs -I {} hyprctl setprop address:{} opaque ofi > /dev/null
    '')
  ];
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;
    configType = "lua";
    extraConfig = ''
      require("binds")
      require("variables")
    '';
  };
  xdg.configFile."hypr" = {
    source = ./config;
    recursive = true;
  };
  xdg.configFile."hypr/colors.lua".source =
    config.lib.stylix.colors {
      template = ./colors.lua.mustache;
      extension = ".lua";
    };
}
