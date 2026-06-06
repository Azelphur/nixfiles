{ ... }:

{
  # udev rule for Keychron Q6 HE, required to make the keychron configurator work
  services.udev.extraRules = ''
    # Keychron Q6 HE
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="3434", ATTRS{idProduct}=="0b61", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
    # Keychron C3 Pro
    KERNEL=="hidraw*", SUBSYSTEM=="hidraw", ATTRS{idVendor}=="3434", ATTRS{idProduct}=="0431", MODE="0660", GROUP="users", TAG+="uaccess", TAG+="udev-acl"
  '';
}
