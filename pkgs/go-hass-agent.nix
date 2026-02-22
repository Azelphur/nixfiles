{ lib, pkgs, buildNpmPackage, buildGoModule, fetchFromGitHub, ...}:

let
  pname = "go-hass-agent";
  version = "14.9.0";

  src = fetchFromGitHub {
    owner = "joshuar";
    repo = "go-hass-agent";
    tag = "v${version}";
    hash = "sha256-vY2a4nSjRzs3QahPXgKIe1YGzp7FRMxscsCP9VH9fYg=";
  };

  nodeAssets = buildNpmPackage {
    pname = "go-hass-agent-assets";
    inherit src version;

    npmDepsHash = "sha256-rScsGZMdyd8chY380MxZEA6OkwqkH46LlvjCTBOohfE=";
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

  vendorHash = "sha256-Lbctnz/YV8taCHpJG9XnheT0W4mVxDlewb/nTP5WnHU=";

  meta = with lib; {
    description = "Go-based Home Assistant agent";
    homepage = "https://github.com/joshuar/go-hass-agent";
    changelog = "https://github.com/joshuar/go-hass-agent/releases/tag/v${finalAttrs.version}";
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
