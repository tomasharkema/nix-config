{
  lib,
  config,
  ...
}: let
  cfg = config.services.ha;
in {
  options.services.ha = {
    enable = lib.mkEnableOption "Enable ha/keepalived";

    interface = lib.mkOption {
      type = lib.types.str;
      default = "zthnhagpcb";
      description = "interface";
    };

    initialMaster = lib.mkEnableOption "initialMaster";
  };
  config = lib.mkIf true {
    services.keepalived = {
      # enable = true;
      # snmp = {
      #   enable = true;
      #   enableKeepalived = true;
      # };

      vrrpInstances."VI_1" = {
        state =
          if cfg.initialMaster
          then "MASTER"
          else "BACKUP";
        virtualRouterId = 69;
        priority =
          if cfg.initialMaster
          then 100
          else 50;
        interface = cfg.interface;

        virtualIps = [
          {
            addr = "172.25.25.25/16";
            dev = cfg.interface;
          }
        ];
      };
    };
  };
}
