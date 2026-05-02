{ lib, pkgs, buildNpmPackage, buildGoModule, fetchFromGitHub, ...}:

let
  pname = "go-hass-agent";
  version = "14.11.0";

  src = fetchFromGitHub {
    owner = "joshuar";
    repo = "go-hass-agent";
    tag = "v${version}";
    hash = "sha256-mC/Y1z2kudBZOEQU5S17ROx3iHPpDGGSkUJe7MMb/iE=";
  };

  nodeAssets = buildNpmPackage {
    pname = "go-hass-agent-assets";
    inherit src version;

    npmDepsHash = "sha256-LwOVVVGWufQ+Q3jiv0H9lf7zg3R9fXvvAlLiUWqtmZs=";
    buildPhase = ''
      runHook preBuild
      npm run build:js
      npm run build:css
      runHook postBuild
    '';
    installPhase = ''
      runHook preInstall
      mkdir -p $out
      cp -r web $out/
      runHook postInstall
    '';
  };
in buildGoModule (finalAttrs: {
  inherit pname version src;

  preBuild = ''
    cp -r ${nodeAssets}/web .
  '';

  ldflags = [
    "-w"
    "-s"
    "-X github.com/joshuar/go-hass-agent/config.AppVersion=${finalAttrs.version}-nixpkgs"
  ];

  vendorHash = "sha256-Xz7u8SSlxlDB5HbKMbm1xVYrtp1/zy2yBgoWS3NcTew=";

  meta = with lib; {
    description = "Home Assistant native app for desktop/laptop devices";
    homepage = "https://github.com/joshuar/go-hass-agent";
    changelog = "https://github.com/joshuar/go-hass-agent/blob/v${finalAttrs.version}/CHANGELOG.md";
    downloadPage = "https://github.com/joshuar/go-hass-agent/";
    longDescription = ''
      Go Hass Agent is an application to expose sensors, controls, and events
      from a device to Home Assistant. You can think of it as something similar
      to the Home Assistant companion app for mobile devices, but for your
      desktop, server, Raspberry Pi, Arduino, toaster, whatever. If it can run
      Go and Linux, it can run Go Hass Agent!
    '';
    license = licenses.mit;
    mainProgram = "go-hass-agent";
    platforms = platforms.linux;
  };
})
