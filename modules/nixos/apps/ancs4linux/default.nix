{
  pkgs,
  config,
  lib,
  ...
}:
with lib; {
  config = {
    services.dbus = {
      enable = true;
      packages = [pkgs.custom.ancs4linux];
    };

    users.groups.ancs4linux.members = ["root" "tomas"];

    systemd = {
      additionalUpstreamSystemUnits = ["ancs4linux-observer" "ancs4linux-advertising"];
      additionalUpstreamUserUnits = ["ancs4linux-desktop-integration"];
      packages = [pkgs.custom.ancs4linux];
    };
  };
}
