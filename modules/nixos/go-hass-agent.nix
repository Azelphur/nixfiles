{ config, lib, pkgs, inputs, ...}:

let
  go-hass-agent = pkgs.buildGoModule (finalAttrs: {
    pname = "go-hass-agent";
    version = "14.0.2";

    src = pkgs.fetchFromGitHub {
      owner = "joshuar";
      repo = "go-hass-agent";
      tag = "v${finalAttrs.version}";
      hash = "sha256-aZsGCyV7Kbp/IrwU0O471rX48uVHvkd3Giefrm3Gbu4=";
    };

    nativeBuildInputs = with pkgs; [
      pkg-config
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

    vendorHash = "sha256-PVicvYGaZxNVUbmNCEGUd4BZklhgaSMKpeiy898YTbM=";
    meta = with pkgs.lib; {
      description = "Go-based Home Assistant agent";
      homepage = "https://github.com/joshuar/go-hass-agent";
      license = licenses.mit;
    };
  });
in
{
  environment.systemPackages = with pkgs; [
    go-hass-agent
  ];
}
