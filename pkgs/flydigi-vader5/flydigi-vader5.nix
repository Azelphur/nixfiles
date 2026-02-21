{ lib
, stdenv
, fetchFromGitHub
, cmake
, ninja
, ftxui
, udevCheckHook
, writeText
}:

stdenv.mkDerivation rec {
  pname = "flydigi-vader5";
  version = "unstable-2026-02-16";

  src = fetchFromGitHub {
    owner = "BANANASJIM";
    repo = "flydigi-vader5";
    rev = "73d77fe57ede47089b7ca0cac1f7ff956fb2a910";
    hash = "sha256-vskl+9SpnNG0tb+DAmPJQSmss6KQb/x6A3uX9uKfm4w=";
  };

  tomlplusplus_src = builtins.fetchTarball{
    url = "https://github.com/marzer/tomlplusplus/archive/refs/tags/v3.4.0.tar.gz";
    sha256 = "sha256:1hvbifzcc97r9jwjzpnq31ynqnj5y93cjz4frmgddnkg8hxmp6w7";
  };

  nativeBuildInputs = [
    cmake
    ftxui
    udevCheckHook
  ];

  patches = [ ./patch.patch ];

  configurePhase = ''
    export tomlplusplus_src=${tomlplusplus_src}
  '';
  cmakeFlags = [
    "-Dtomlplusplus_src=${tomlplusplus_src}"
    "-DCMAKE_BUILD_TYPE=Release"
  ];

  buildPhase = ''
    mkdir -p build
    cd build
    cmake ..
    cmake --build .
  '';

  installPhase = ''
    runHook preInstall
    mkdir -p $out/bin
    install -Dm755 ./vader5d $out/bin/vader5d
    install -Dm755 ./vader5-debug $out/bin/vader5-debug
    runHook postInstall
  '';

  meta = with lib; {
    description = "Linux driver for Flydigi Vader 5 Pro gamepad - Xbox Elite emulation, gyro, layers, button remap";
    license = licenses.gpl2;
    platforms = platforms.linux;
  };
}
