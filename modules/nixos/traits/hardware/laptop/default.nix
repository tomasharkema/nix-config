{
  lib,
  config,
  inputs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.traits.hardware.laptop;
in {
  options.traits = {
    hardware.laptop = {
      enable = mkBoolOpt false "laptop";
    };
  };

  config = mkIf cfg.enable {
    system.nixos.tags = ["laptop"];
    powerManagement.enable = true;

    # environment.systemPackages =
    #   [ inputs.nbfc-linux.packages.x86_64-linux.default ];

    services = {
      synergy.server = {
        enable = true;
      };

      thermald.enable = true;

      xrdp.enable = mkForce false;

      auto-cpufreq = {
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
