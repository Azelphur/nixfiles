{ pkgs, ... }:

let
  smart_posix = pkgs.writeShellApplication {
    name = "smart_posix";
    runtimeEnv = {
     MK_SOURCE_ONLY = ""; # if unset, check crashes
    };
    runtimeInputs = [ pkgs.smartmontools pkgs.lsiutil ];
    text = builtins.readFile ./smart_posix;
    checkPhase = ""; 
  };
  mk_docker = pkgs.writers.writePython3Bin "mk_docker" {
    libraries = [ pkgs.python3Packages.docker pkgs.docker ];
    doCheck = false;
  } (builtins.readFile ./mk_docker.py);
  docker_health = pkgs.writers.writePython3Bin "docker_health" {
    libraries = [ pkgs.python3Packages.docker pkgs.docker ];
    doCheck = false;
  } (builtins.readFile ./docker_health.py);
in {
  # New checkmk doesn't listen on 6556 unless you allow legacy allow-legacy-pull
  systemd.tmpfiles.rules = [
    "f /var/lib/check_mk_agent/allow-legacy-pull 0644 root root -"
    "L /bin/bash - - - - /run/current-system/sw/bin/bash"
  ];
  services.checkmk-agent = {
    enable = true;
    package = pkgs.checkmk-agent.override {
      plugins = [
        (pkgs.runCommandNoCC "smart_posix" {} ''
          mkdir -p $out
          ln -s ${smart_posix}/bin/smart_posix $out/smart_posix
        '')
        (pkgs.runCommandNoCC "mk_docker" { nativeBuildInputs = [ pkgs.makeWrapper ]; } ''
          mkdir -p $out
          makeWrapper ${mk_docker}/bin/mk_docker $out/mk_docker \
            --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.docker ]}
        '')
        (pkgs.runCommandNoCC "docker_health" { nativeBuildInputs = [ pkgs.makeWrapper ]; } ''
          mkdir -p $out
          makeWrapper ${docker_health}/bin/docker_health $out/docker_health \
            --prefix PATH : ${pkgs.lib.makeBinPath [ pkgs.docker ]}
        '')
      ];
    };
  };
}
