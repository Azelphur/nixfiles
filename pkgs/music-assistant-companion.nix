{
  lib,
  stdenv,
  fetchFromGitHub,
  cargo-tauri,
  jq,
  libsoup_3,
  moreutils,
  nodejs,
  openssl,
  pkg-config,
  rustPlatform,
  webkitgtk_4_1,
  wrapGAppsHook3,
  yarn,
  fetchYarnDeps,
  alsa-lib,
  pulseaudio,
  libappindicator,
  libayatana-appindicator,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "music-assistant-companion";
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "music-assistant";
    repo = "desktop-app";
    rev = "${finalAttrs.version}";
    hash = "sha256-lIiMq3QZemCkxIMjl+BXyMi8q6t3j7iOMUQ6UUhoVUg=";
  };

  cargoRoot = "src-tauri";
  buildAndTestSubdir = finalAttrs.cargoRoot;

  yarnDeps = fetchYarnDeps {
    yarnLock = "${finalAttrs.src}/yarn.lock";
    hash = "sha256-dOJ5ETRodpnuaI+L2wckNU0XANUcjqzvdqw/cd5sJC4=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs)
      pname
      version
      src
      cargoRoot
      ;
    hash = "sha256-m+/m2tGsqdV2mBJkoekiiRtT2ok2bpOiTmqEh+Gal20=";
  };

  nativeBuildInputs = [
    cargo-tauri.hook
    jq
    moreutils
    nodejs
    pkg-config
    rustPlatform.cargoSetupHook
    wrapGAppsHook3
    yarn
    nodejs
  ];

  buildInputs = [
    libsoup_3
    openssl
    webkitgtk_4_1
    alsa-lib
    pulseaudio
    libayatana-appindicator
    libappindicator
  ];

  passthru.updateScript = nix-update-script { };

  # At the end of buildPhase or installPhase, wrap the binary
  installPhase = ''
    mkdir -p $out/bin
    ls -R
    cp ./target/x86_64-unknown-linux-gnu/release/music-assistant-companion $out/bin/
    wrapProgram $out/bin/music-assistant-companion \
      --prefix LD_LIBRARY_PATH : ${libayatana-appindicator}/lib:${libappindicator}/lib
  '';

  meta = {
    description = "Music assistant desktop companion app";
    homepage = "https://wealthfolio.app/";
    license = lib.licenses.agpl3Only;
    mainProgram = "music-assistant-companion";
    platforms = lib.platforms.linux;
  };
})
