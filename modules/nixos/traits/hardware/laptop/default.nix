{ lib, config, ... }:
with lib;
with lib.custom;
let cfg = config.traits.hardware.laptop;
in {
  options.traits = {
    hardware.laptop = { enable = mkBoolOpt false "laptop"; };
  };

  config = mkIf cfg.enable {
    system.nixos.tags = [ "laptop" ];
    powerManagement.enable = true;
    services.thermald.enable = true;

    services.xrdp.enable = mkForce false;

    services.auto-cpufreq = {
      enable = true;
      settings = {
        battery = {
          governor = "powersave";
          turbo = "never";
        };
        charger = {
          governor = "performance";
          turbo = "auto";
        };
      };
    };
    # services.tlp.enable = true;
    systemd.targets = {
      sleep.enable = true;
      suspend.enable = true;
      hibernate.enable = true;
      hybrid-sleep.enable = true;
    };
  };
}
