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
      groups.ipmi = {
        gid = 964;
        members = [
          "tomas"
          "root"
          "netdata"
          "ipmi-exporter"
        ];
      };
    };

    services = {
      udev.extraRules = ''
        KERNEL=="ipmi*", MODE="660", GROUP="ipmi"
      '';
      # SUBSYSTEM=="ipmi", GROUP="ipmi", MODE="0777"

      prometheus.exporters.ipmi = {
        enable = true;
        group = "ipmi";
      };
    };
  };
}
