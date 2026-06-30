{ config, pkgs, inputs, ... }:

{
  imports = [
    inputs.nixcord.homeModules.nixcord
  ];

  #stylix.targets.vesktop.enable = true;
  programs.nixcord = {
    enable = true;  # enable Nixcord. Also installs discord package
    discord.vencord.enable = true;
    config = {
      enabledThemes = [
        "stylix.theme.css"
      ];
      frameless = true; # set some Vencord options
      plugins = {
        alwaysTrust.enable = true;
        clearUrls.enable = true;  
        copyFileContents.enable = true;
        customRpc.enable = true;
        forceOwnerCrown.enable = true;
        imageZoom.enable = true;
        memberCount.enable = true;
        messageLinkEmbeds.enable = true;
        messageLogger.enable = true;
        noF1.enable = true;
        permissionsViewer.enable = true;
        pinDms.enable = true;
        previewMessage.enable = true;
        serverInfo.enable = true;
        showHiddenChannels.enable = true;
        unlockedAvatarZoom.enable = true;
        viewRaw.enable = true;
        voiceDownload.enable = true;
        webScreenShareFixes.enable = true;
        whoReacted.enable = true;
      };
    };
    extraConfig = {
      # Some extra JSON config here
      # ...
    };
  };
}
