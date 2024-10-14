{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.traits.hardware.disable-sleep;
in {
  options.traits.hardware.disable-sleep = {
    enable = lib.mkEnableOption "disable sleep";
  };

  config = lib.mkIf cfg.enable {
    powerManagement.enable = lib.mkForce false;

    systemd = {
      targets = {
        sleep.enable = lib.mkForce false;
        suspend.enable = lib.mkForce false;
        hibernate.enable = lib.mkForce false;
        hybrid-sleep.enable = lib.mkForce false;
      };
      sleep.extraConfig = ''
        AllowSuspend=no
        AllowHibernation=no
        AllowHybridSleep=no
        AllowSuspendThenHibernate=no
      '';
    };
  };
}
