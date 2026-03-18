{pkgs, ...}: let
  pname = "crunchyroll-linux";
  version = "1.1.2";
  src = pkgs.fetchurl {
    url = "https://github.com/aarron-lee/crunchyroll-linux/releases/download/v1.1.2/Crunchyroll_v1.1.2_linux.AppImage";
    hash = "sha256-0QmPQcpnQRiKU5qoVEVzC8sHvqWdlSoa079Edz7gyHk=";
  };
  appimageContents = pkgs.appimageTools.extract {inherit pname version src;};
in
  pkgs.appimageTools.wrapType2 {
    inherit pname version src;
    pkgs = pkgs;

    extraInstallCommands = ''
      install -m 444 -D ${appimageContents}/${pname}.desktop -t $out/share/applications
      substituteInPlace $out/share/applications/${pname}.desktop --replace 'Exec=AppRun --no-sandbox %U' 'Exec=${pname}'
      cp -r ${appimageContents}/usr/share/icons $out/share
    '';
  }
