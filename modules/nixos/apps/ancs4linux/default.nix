{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  package = pkgs.custom.ancs4linux;
in {
  config = {
    environment.systemPackages = [package pkgs.custom.bluetooth-autoconnect];

    services.dbus = {
      enable = true;
      packages = [package];
    };

    users.groups.ancs4linux.members = ["root" "tomas"];

    services.packagekit.enable = true;

    systemd = {
      packages = [package pkgs.custom.bluetooth-autoconnect];
      services = {
        ancs4linux-advertising = {
          enable = true;
          description = "ancs4linux Advertising daemon";
          requires = ["bluetooth.service"];
          after = ["bluetooth.service"];
          wantedBy = ["default.target"];

          serviceConfig = {
            Type = "dbus";
            BusName = "ancs4linux.Advertising";
            ExecStart = "${package}/bin/ancs4linux-advertising";
            Restart = "on-failure";
            RestartSec = "5s";
          };
        };
        ancs4linux-observer = {
          enable = true;
          description = "ancs4linux Observer daemon";
          requires = ["bluetooth.service"];
          after = ["bluetooth.service"];
          wantedBy = ["default.target"];

          serviceConfig = {
            Type = "dbus";
            BusName = "ancs4linux.Observer";
            ExecStart = "${package}/bin/ancs4linux-observer";
            Restart = "on-failure";
            RestartSec = "5s";
          };
        };
      };
      user.services.ancs4linux-desktop-integration = {
        enable = true;
        unitConfig = {
          Description = "ancs4linux Desktop Integration daemon (should run as user)";
          Requires = "bluetooth.target";
          After = "bluetooth.target";
        };
        serviceConfig = {
          Type = "simple";
          ExecStart = "${package}/bin/ancs4linux-desktop-integration";
          Restart = "on-failure";
          RestartSec = "5s";
        };

        wantedBy = ["default.target"];
      };
    };
  };
}
