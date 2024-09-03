{ config, pkgs, ... }:

{
  home.packages = with pkgs; [
    dunst
  ];
  services.dunst = {
    enable = true;
    settings = {
      global = {
        follow = "none";
        gap_size = 10;
	width = 600;
	height = 150;
	offset = "30x30";
	origin = "top-right";
	indicate_hidden = "yes";
	shrink = "no";
	transparency = 50;
	separator_height = 2;
	padding = 8;
	horizontal_padding = 8;
	frame_width = 3;
	sort = "yes";
	idle_threshold = 0;
	line_height = 0;
	markup = "full";
	format = "<b>%s</b>\\n%b";
	alignment = "left";
	vertical_alignment = "center";
        show_age_threshold = 60;
	word_wrap = "yes";
	ellipsize = "middle";
	ignore_newline = "no";
	stack_duplicates = false;
	hide_duplicate_count = false;
        show_indicators = "no";
	icon_position = "left";
	min_icon_size = 64;
        max_icon_size = 64;
	sticky_history = "yes";
	history_length = 20;
	browser = "firefox -new-tab";
	always_run_script = "true";
	title = "Dunst";
	class = "Dunst";
	corner_radius = 10;
	ignore_dbusclose = "false";
	force_xinerama = "false";
	mouse_left_click = "do_action, close_current";
	mouse_middle_click = "do_action, close_current";
	mouse_right_click = "close_all";
      };
      experimental = {
        per_monitor_dpi = "true";
      };
    };
  };
}
