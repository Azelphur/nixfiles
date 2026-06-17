{ pkgs ? import <nixpkgs> { } }:

pkgs.stdenv.mkDerivation rec {
    pname = "uvtools";
    version = "v6.0.1";

    src = builtins.fetchurl {
        url = "https://github.com/sn4k3/UVtools/releases/download/${version}/UVtools_linux-x64_${version}.AppImage";
        sha256 = "sha256:1syncv0pgnky70nw7wxjpryqn98nzv4cxs4w0cn2irg0vp6ya42i";
    };

    nativeBuildInputs = [
        pkgs.qt5.wrapQtAppsHook
        pkgs.coreutils
        pkgs.qt5.qtwayland
        pkgs.qt5.qttools
        pkgs.dbus
        pkgs.gtk3
        pkgs.qt5.qtbase
        pkgs.mono
        pkgs.bash
        pkgs.steam-run
        pkgs.icu
        pkgs.ffmpeg
        pkgs.fuse
        pkgs.libdc1394
        pkgs.libgdiplus
        pkgs.libgeotiff
        pkgs.libjpeg_turbo
        pkgs.libpng
        pkgs.openexr
        pkgs.openjpeg
        pkgs.tbb
        pkgs.zlib
    ];

    unpackPhase = "true";
    buildPhase = "true";

    installPhase = ''
    echo "Creating a wrapper for UVtools"
    mkdir -p $out/bin

    cat > $out/bin/uvtools <<EOF
    #!/bin/sh
    exec env LD_LIBRARY_PATH=${pkgs.icu}/lib:\$LD_LIBRARY_PATH \
    ${pkgs.appimage-run}/bin/appimage-run ${src} "\$@"
    EOF
    chmod +x $out/bin/uvtools
    '';

    meta = with pkgs.lib; {
        description = "3D Print File Analysis and Repair Tool";
        homepage = "https://github.com/sn4k3/UVtools";
        license = licenses.gpl3;
        platforms = [ "x86_64-linux" ];
    };
}
