{ pkgs, ... }:

let
  smart_posix = pkgs.writeShellApplication {
    name = "smart_posix";
    runtimeEnv = {
     MK_SOURCE_ONLY = ""; # if unset, check crashes
    };
    runtimeInputs = [ pkgs.smartmontools ];
    text = builtins.readFile ./smart_posix;
    checkPhase = ""; 
  };
in {
  # New checkmk doesn't listen on 6556 unless you allow legacy allow-legacy-pull
  systemd.tmpfiles.rules = [
    "f /var/lib/check_mk_agent/allow-legacy-pull 0644 root root -"
  ];
  services.cmk-agent = {
    enable = true;
    package = pkgs.checkmk-agent.override {
      plugins = [
        (pkgs.runCommandNoCC "smart_posix" {} ''
          echo $out
          mkdir -p $out
          ln -s ${smart_posix}/bin/smart_posix $out/smart_posix
        '')
      ];
    };
  };
}
