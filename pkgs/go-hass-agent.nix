{ lib, pkgs, ...}:

let
  src = pkgs.fetchFromGitHub {
    owner = "joshuar";
    repo = "go-hass-agent";
    tag = "v14.8.0";

    hash = "sha256-MHQCJLvy3YnDeXal29+zwSAYCeVCisa9se1+GCIiIvw=";
  };

  nodeAssets = pkgs.buildNpmPackage {
    pname = "go-hass-agent-assets";
    version = "14.8.0";
    inherit src;

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
      cp -r web $out/web
      cp -r node_modules $out/node_modules
      runHook postInstall
    '';
  };
in pkgs.buildGoModule (finalAttrs: {
  pname = "go-hass-agent";
  version = "14.8.0";
  inherit src;

  nativeBuildInputs = with pkgs; [
    pkg-config
    git
    breakpointHook
  ];

  subPackages = [ "." ];

  buildInputs = with pkgs; [
    xorg.libX11
    xorg.libXrandr
    xorg.libXxf86vm
    xorg.libXi
    xorg.libXcursor
    xorg.libXinerama
    xorg.libXext
    xorg.libxcb
    mesa
    glfw
  ];
  preBuild = ''
    cp -r ${nodeAssets}/web/* ./web
    cp -r ${nodeAssets}/node_modules ./node_modules
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
  };
})
