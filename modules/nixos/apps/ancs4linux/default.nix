{
  pkgs,
  config,
  lib,
  ...
}:
with lib; let
  cfg = config.apps.ancs4linux;
in {
  options.apps.ancs4linux = {
    enable = mkOption {
      default = config.hardware.bluetooth.enable;
      description = "ancs4linux";
    };
    package = mkOption {
      default = pkgs.custom.ancs4linux;
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [cfg.package pkgs.custom.bluetooth-autoconnect];

    services.dbus = {
      enable = true;
      packages = [cfg.package];
    };

    users.groups.ancs4linux.members = ["root" "tomas"];

    services.packagekit.enable = true;

    systemd = {
      packages = [cfg.package pkgs.custom.bluetooth-autoconnect];
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
            ExecStart = "${cfg.package}/bin/ancs4linux-advertising";
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
            ExecStart = "${cfg.package}/bin/ancs4linux-observer";
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
          ExecStart = "${cfg.package}/bin/ancs4linux-desktop-integration";
          Restart = "on-failure";
          RestartSec = "5s";
        };

        wantedBy = ["default.target"];
      };
    };
  };
}
