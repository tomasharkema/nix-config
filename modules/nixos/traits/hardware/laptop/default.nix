{
  lib,
  config,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.traits.hardware.laptop;
in {
  options.traits = {
    hardware.laptop = {
      enable = mkBoolOpt false "SnowflakeOS GNOME configuration";
    };
  };

  config = mkIf cfg.enable {
    system.nixos.tags = ["laptop"];
    powerManagement.enable = true;
    services.thermald.enable = true;

    netdata.enable = mkForce false;

    services.auto-cpufreq.enable = true;
    services.auto-cpufreq.settings = {
      battery = {
        governor = "powersave";
        turbo = "never";
      };
      charger = {
        governor = "performance";
        turbo = "auto";
      };
    };

    # services.cockpit.enable = mkForce false;

    systemd.targets.sleep.enable = true;
    systemd.targets.suspend.enable = true;
    systemd.targets.hibernate.enable = true;
    systemd.targets.hybrid-sleep.enable = true;
  };
}
