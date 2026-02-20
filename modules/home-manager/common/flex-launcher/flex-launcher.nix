{ config, pkgs, ... }:

{
  home.file = {
  
    ".config/autostart/flex-launcher.desktop".source = "${pkgs.flex-launcher}/share/applications/flex-launcher.desktop";
    "Desktop/flex-launcher.desktop".source = "${pkgs.flex-launcher}/share/applications/flex-launcher.desktop";
    ".config/flex-launcher/background.png".source = ./assets/background.png;
    ".config/flex-launcher/jellyfin.png".source = ./assets/jellyfin.png;
    ".config/flex-launcher/exit.png".source = ./assets/exit.png;
    ".config/flex-launcher/moonlight.png".source = ./assets/moonlight.png;
    ".config/flex-launcher/shudder.png".source = ./assets/shudder.png;
    ".config/flex-launcher/floatplane.png".source = ./assets/floatplane.png;
    ".config/flex-launcher/homeassistant.png".source = ./assets/homeassistant.png;
    ".config/flex-launcher/crunchyroll.png".source = ./assets/crunchyroll.png;
    ".config/flex-launcher/musicassistant.png".source = ./assets/musicassistant.png;
    ".config/flex-launcher/config.ini".text = ''
# Flex Launcher v2.2 sample configuration file
# For documentation of these settings, visit: https://complexlogic.github.io/flex-launcher/configuration
[General]
DefaultMenu=Main
VSync=true
#FPSLimit=
#ApplicationTimeout=15
OnLaunch=Blank
WrapEntries=false
ResetOnBack=false
MouseSelect=true
InhibitOSScreensaver=false
#StartupCmd=
#QuitCmd=

[Background]
Mode=Image
#Color=#000000
Image=/home/azelphur/.config/flex-launcher/background.png
#SlideshowDirectory=
#SlideshowImageDuration=30
#SlideshowTransitionTime=3
#ChromaKeyColor=#010101
Overlay=false
OverlayColor=#000000
OverlayOpacity=50%

[Layout]
MaxButtons=8
IconSize=256
IconSpacing=5%
VCenter=50%

[Titles]
Enabled=true
Font=/nix/store/j5qcbqzz3baza8s7yqxjd3ac3hn7y5w7-flex-launcher-2.2/share/flex-launcher/assets/fonts/OpenSans-Regular.ttf
FontSize=36
Color=#FFFFFF
Opacity=90%
Shadows=true
ShadowColor=#8aadf4
OversizeMode=Shrink
Padding=20

[Highlight]
Enabled=true
FillColor=#FFFFFF
FillOpacity=25%
OutlineSize=0
OutlineColor=#0000FF
OutlineOpacity=100%
CornerRadius=30
VPadding=30
HPadding=30

[Scroll Indicators]
Enabled=true
FillColor=#FFFFFF
OutlineSize=0
OutlineColor=#000000
Opacity=100%

[Clock]
Enabled=true
ShowDate=true
Alignment=Right
Font=/nix/store/j5qcbqzz3baza8s7yqxjd3ac3hn7y5w7-flex-launcher-2.2/share/flex-launcher/assets/fonts/SourceSansPro-Regular.ttf
FontSize=50
FontColor=#FFFFFF
Shadows=false
ShadowColor=#000000
Margin=5%
Opacity=100%
TimeFormat=Auto
DateFormat=Auto
IncludeWeekday=true

[Screensaver]
Enabled=false
IdleTime=300
Intensity=70%
PauseSlideshow=true

[Hotkeys]
# Esc to quit
Hotkey1=#1B;:quit

[Gamepad]
Enabled=true
DeviceIndex=-1
#ControllerMappingsFile=
LStickX-=:left
LStickX+=:right
#LStickY-=
#LStickY+=
#RStickX-=
#RStickX+=
#RStickY-=
#RStickY+=
#LTrigger=
#RTrigger=
ButtonA=:select
ButtonB=:back
#ButtonX=
#ButtonY=
#ButtonBack=
#ButtonGuide=
#ButtonStart=
#ButtonLeftStick=
#ButtonRightStick=
#ButtonLeftShoulder=
#ButtonRightShoulder=
#ButtonDPadUp=
#ButtonDPadDown=
ButtonDPadLeft=:left
ButtonDPadRight=:right

# Menu configurations
[Main]
Entry1=Jellyfin;/home/azelphur/.config/flex-launcher/jellyfin.png;jellyfin-desktop --tv --fullscreen
Entry2=VacuumTube;${pkgs.vacuum-tube}/share/icons/hicolor/256x256/apps/rocks.shy.VacuumTube.png;VacuumTube
Entry3=Moonlight;/home/azelphur/.config/flex-launcher/moonlight.png;moonlight
# Logging out drops us back into the steam session
Entry4=Steam;${pkgs.flex-launcher}/share/flex-launcher/assets/icons/steam.png;qdbus org.kde.Shutdown /Shutdown org.kde.Shutdown.logout
Entry5=Crunchyroll;/home/azelphur/.config/flex-launcher/crunchyroll.png;google-chrome-stable --kiosk --no-first-run --disable-infobars https://www.crunchyroll.com/
Entry6=Shudder;/home/azelphur/.config/flex-launcher/shudder.png;google-chrome-stable --kiosk --no-first-run --disable-infobars https://www.shudder.com/
Entry7=Floatplane;/home/azelphur/.config/flex-launcher/floatplane.png;google-chrome-stable --kiosk --no-first-run --disable-infobars https://www.floatplane.com/channel/linustechtips/home/main
Entry8=Music Assistant;/home/azelphur/.config/flex-launcher/musicassistant.png;google-chrome-stable --kiosk --no-first-run --disable-infobars https://musicassistant.home.azelphur.com
Entry9=Home Assistant;/home/azelphur/.config/flex-launcher/homeassistant.png;google-chrome-stable --kiosk --no-first-run --disable-infobars https://homeassistant.home.azelphur.com
Entry10=Kodi;${pkgs.flex-launcher}/share/flex-launcher/assets/icons/kodi.png;kodi
Entry11=System;${pkgs.flex-launcher}/share/flex-launcher/assets/icons/system.png;:submenu System

[System]
Entry1=Exit;/home/azelphur/.config/flex-launcher/exit.png;:quit
Entry2=Shutdown;${pkgs.flex-launcher}/share/flex-launcher/assets/icons/system.png;:shutdown
Entry3=Restart;${pkgs.flex-launcher}/share/flex-launcher/assets/icons/restart.png;:restart
Entry4=Sleep;${pkgs.flex-launcher}/share/flex-launcher/assets/icons/sleep.png;:sleep
    '';
    };
}

