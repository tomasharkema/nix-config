{
  config,
  lib,
  ...
}: let
  cfg = config.traits.hardware.iwd;
in {
  options = {
    traits.hardware.iwd = {
      enable = lib.mkEnableOption "";
    };
  };

  config = {
    networking = lib.mkIf cfg.enable {
      networkmanager = {
        enable = true;
        wifi = {
          backend = "iwd";
        };
      };

      wireless = {
        enable = false;
        iwd = {
          enable = true;
          settings = {
            Settings = {
              AutoConnect = true;
              AlwaysRandomizeAddress = true;
            };
            Network = {
              EnableIPv6 = true;
              RoutePriorityOffset = 300;
            };
            DriverQuirks.DefaultInterface = "wlan0";
          };
        };
      };
    };
  };
}
