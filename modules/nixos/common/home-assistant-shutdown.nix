{ ... }:

# Allow home assistant to SSH in and run shutdown (and only shutdown)

{
  users.users.homeassistant = {
    isNormalUser = false;
    isSystemUser = true;
    description = "Shutdown-only SSH user";
    home = "/var/empty";
    shell = "/run/current-system/sw/bin/sh";
    group = "homeassistant";

    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCyNS0gBxrQeOw95M3QSZ6n3oIbcw23gXF7mc0tDT3/mXNI+BxFQAxEyHiE0GDOtYXaswN4zCWjcgXtEKG4dPTJXI1tque1cZPlilgAcyXoK48FG5J6Ms1+Cv7ZYfNjg7Yl82pNwKDz+YF0P6fLmOYYAIM+rej1Yp43mMPcVueSRnk3i2BGxdiLQtMb8JpX1VHuUZqIOL+gjFT6sZdLMNO+gB5vYoJsUdYODO5pWOM/PA3Ov+rVbKoHKK8ErPhIMe5i7MZ7GTNxPMahq69w6HIHnXElNPBfLOmX3h+8GlNXu37epqPjmud2Gej9vE9tG/TnIzpxVGC/AMnlVs98LqKNOOGNp0uGTx5/lqTsnC0liTcKY6IUaZ3maCHT+WkjfuiMpUiL/Yo27Q2h29k1sMwZJ7iXWRJunROmQSdPw/YCeJxi0X2tGtfahw7dQSfgcj/8gB0RiMTYBRbsTf/u2xmfnp1sZpKe6Brq0Bo4YjH53u+RyN5UR25IWHA0gfuMnxs="
    ];
  };
  users.groups.homeassistant = {};

  services.openssh.extraConfig = ''
    Match User homeassistant
      # Do not allow PTY (stops interactive shells)
      PermitTTY no

      # Do not allow port forwarding, agent forwarding, or anything else
      AllowTcpForwarding no
      X11Forwarding no
      PermitTunnel no

      # Ignore any command supplied by client (ssh user@host command)
      # Always run shutdown instead
      ForceCommand /run/current-system/sw/sbin/shutdown -h now
  '';

  security.polkit.extraConfig = ''
    polkit.addRule(function(action, subject) {
      if (
        subject.isInGroup("homeassistant") &&
        (action.id == "org.freedesktop.login1.power-off" ||
         action.id == "org.freedesktop.login1.power-off-multiple-sessions" ||
         action.id == "org.freedesktop.login1.halt" ||
         action.id == "org.freedesktop.login1.halt-multiple-sessions")
      ) {
        return polkit.Result.YES;
      }
    });
  '';
}
