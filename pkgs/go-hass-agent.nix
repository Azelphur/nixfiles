{ lib, pkgs, ...}:

let
  pname = "go-hass-agent";
  version = "14.8.0";

  src = pkgs.fetchFromGitHub {
    owner = "joshuar";
    repo = "go-hass-agent";
    tag = "v${version}";
    hash = "sha256-MHQCJLvy3YnDeXal29+zwSAYCeVCisa9se1+GCIiIvw=";
  };

  nodeAssets = pkgs.buildNpmPackage {
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
in pkgs.buildGoModule (finalAttrs: {
  inherit pname version src;

  preBuild = ''
    cp -r ${nodeAssets}/web .
  '';

  ldflags = [
    "-w"
    "-s"
    "-X github.com/joshuar/go-hass-agent/config.AppVersion=${finalAttrs.version}-nixpkgs"
  ];

  vendorHash = "sha256-D90MuhN8TwzISqT/c26Fk2HFsSsB5k9WOcS4olZuQ3w=";

  meta = with pkgs.lib; {
    description = "Go-based Home Assistant agent";
    homepage = "https://github.com/joshuar/go-hass-agent";
    license = licenses.mit;
    mainProgram = "go-hass-agent";
    platforms = platforms.linux;
  };
})
