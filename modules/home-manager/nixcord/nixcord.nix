{ config, pkgs, inputs, ... }:

{
  imports = [
    inputs.nixcord.homeManagerModules.nixcord
  ];

  stylix.targets.vesktop.enable = true;
  programs.nixcord = {
    enable = true;  # enable Nixcord. Also installs discord package
    discord.enable = false;
    vesktop.enable = true;
    #quickCss = "some CSS";  # quickCSS file
    config = {
      #useQuickCss = true;   # use out quickCSS
      #themeLinks = [        # or use an online theme
      #  "https://raw.githubusercontent.com/link/to/some/theme.css"
      #];
      enabledThemes = [
        "stylix.theme.css"
      ];
      frameless = true; # set some Vencord options
      plugins = {
        alwaysTrust.enable = true;
	copyFileContents.enable = true;
	customRPC.enable = true;
	forceOwnerCrown.enable = true;
	imageZoom.enable = true;
	memberCount.enable = true;
	messageLinkEmbeds.enable = true;
	messageLogger.enable = true;
	permissionsViewer.enable = true;
	pinDMs.enable = true;
	previewMessage.enable = true;
	viewRaw.enable = true;
	voiceDownload.enable = true;
	whoReacted.enable = true;
      };
    };
    extraConfig = {
      # Some extra JSON config here
      # ...
    };
  };
}