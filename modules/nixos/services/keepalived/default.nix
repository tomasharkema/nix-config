{
  lib,
  config,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.services.ha;
in {
  options.services.ha = {
    enable = mkBoolOpt true "Enable ha/keepalived";

    interface = mkOpt types.str "zthnhagpcb" "interface";

    initialMaster = mkBoolOpt false "initialMaster";
  };
  config = mkIf true {
    services.keepalived = {
      enable = true;
      # openFirewall = true;
      snmp = {
        enable = true;
        enableKeepalived = true;
      };

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
      };
    };
  };
}
