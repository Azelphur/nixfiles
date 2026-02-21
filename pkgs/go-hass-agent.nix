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

    installPhase = ''
      mkdir -p $out
      cp -r dist/* $out/
      cp -r node_modules $out/
    '';
  };

in pkgs.buildGoModule (finalAttrs: {
  pname = "go-hass-agent";
  version = "14.8.0";
  inherit src;


  #src = /home/azelphur/Code/github/go-hass-agent;

  nativeBuildInputs = with pkgs; [
    pkg-config
    git
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

  ldflags = [
    "-w"
    "-s"
    "-X github.com/joshuar/go-hass-agent/config.AppVersion=${finalAttrs.version}-nixpkgs"
  ];

  #buildPhase = ''
  #  CGO_ENABLED=0 go build -ldflags="-w -s -X github.com/joshuar/go-hass-agent/config.AppVersion=14.8.0-nix" -o dist/go-hass-agent
  #'';
  #installPhase = ''
  #  mkdir $out/bin
  #  install -Dm755 ./dist/go-hass-agent $out/bin/go-hass-agent
  #'';

  vendorHash = "sha256-D90MuhN8TwzISqT/c26Fk2HFsSsB5k9WOcS4olZuQ3w=";
  meta = with pkgs.lib; {
    description = "Go-based Home Assistant agent";
    homepage = "https://github.com/joshuar/go-hass-agent";
    license = licenses.mit;
  };
})
