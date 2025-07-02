{
  lib,
  config,
  ...
}: let
  cfg = config.traits.server.ipmi;
in {
  options.traits.server.ipmi = {
    enable = lib.mkEnableOption "ipmi";
  };

  config = lib.mkIf cfg.enable {
    users = {
      groups.ipmi.members = [
        "tomas"
        "root"
        "netdata"
        "ipmi-exporter"
      ];
    };

    services = {
      udev.extraRules = ''
        SUBSYSTEM=="ipmi", GROUP="ipmi", MODE="0777"
      '';

      prometheus.exporters.ipmi = {
        enable = true;
        group = "ipmi";
      };
    };
  };
}
