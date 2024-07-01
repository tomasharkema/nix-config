{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.traits.hardware.disable-sleep;
in {
  options.traits.hardware.disable-sleep = {
    enable = mkEnableOption "disable sleep";
  };

  config = mkIf cfg.enable {
    powerManagement.enable = false;

    systemd = {
      targets = {
        sleep.enable = mkForce false;
        suspend.enable = mkForce false;
        hibernate.enable = mkForce false;
        hybrid-sleep.enable = mkForce false;
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
