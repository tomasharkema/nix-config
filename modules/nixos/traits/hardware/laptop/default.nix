{
  lib,
  config,
  inputs,
  pkgs,
  ...
}: let
  cfg = config.traits.hardware.laptop;
in {
  options.traits.hardware.laptop = {
    enable = lib.mkEnableOption "laptop";
  };

  config = lib.mkIf cfg.enable {
    system.nixos.tags = ["laptop"];
    powerManagement.enable = true;

    # environment.systemPackages = [pkgs.custom.tlpui];

    home-manager.users.tomas.programs.gnome-shell.extensions =
      lib.optional
      (!config.traits.hardware.laptop.thinkpad.enable)
      {package = pkgs.gnomeExtensions.battery-health-charging;};

    gui.rdp = {
      enable = false;
      legacy = false;
    };

    # boot.kernelParams = [
    #   "ahci.mobile_lpm_policy=3"
    #   "rtc_cmos.use_acpi_alarm=1"
    # ];

    # systemd.packages = [pkgs.tlp];

    services = {
      # synergy.server = {
      #   enable = true;
      # };
      sysstat.enable = false;

      thermald.enable = true;

      netdata.enable = lib.mkForce false;
      prometheus.enable = lib.mkForce false;

      # xrdp.enable = mkForce false;

      tlp = lib.mkIf false {
        enable = true;
        settings = {
          CPU_SCALING_GOVERNOR_ON_AC = "performance";
          CPU_SCALING_GOVERNOR_ON_BAT = "powersave";

          CPU_ENERGY_PERF_POLICY_ON_BAT = "power";
          CPU_ENERGY_PERF_POLICY_ON_AC = "performance";
          CPU_BOOST_ON_AC = 1;
          CPU_BOOST_ON_BAT = 0;
          #CPU_MIN_PERF_ON_AC = 0;
          #CPU_MAX_PERF_ON_AC = 100;
          #CPU_MIN_PERF_ON_BAT = 0;
          #CPU_MAX_PERF_ON_BAT = 70;

          #Optional helps save long term battery health
          START_CHARGE_THRESH_BAT0 = 75; # 40 and below it starts to charge
          STOP_CHARGE_THRESH_BAT0 = 80; # 80 and above it stops charging
          START_CHARGE_THRESH_BAT1 = 75; # 40 and below it starts to charge
          STOP_CHARGE_THRESH_BAT1 = 80; # 80 and above it stops charging
        };
      };

      power-profiles-daemon.enable = true;

      acpid = {
        enable = true;
        logEvents = true;

        acEventCommands = let
          systemctl = "${pkgs.systemd}/bin/systemctl";
          ppd = "${pkgs.power-profiles-daemon}/bin/powerprofilesctl";
        in ''
          case "$@" in
            *00000001)
              ${systemctl} start --no-block beesd@root.service
              ${ppd} set performance
             ;;

            *00000000)
              ${systemctl} stop --no-block beesd@root.service
              ${ppd} set balanced
             ;;
          esac
        '';
      };
    };
  };
}
