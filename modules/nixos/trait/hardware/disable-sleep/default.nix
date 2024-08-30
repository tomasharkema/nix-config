{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.trait.hardware.disable-sleep;
in {
  options.trait.hardware.disable-sleep = {
    enable = mkEnableOption "disable sleep";
  };

  config = mkIf cfg.enable {
    powerManagement.enable = mkForce false;

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
