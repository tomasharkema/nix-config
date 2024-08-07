{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:
with lib; let
  cfg = config.trait.hardware.laptop;
in {
  options.trait.hardware.laptop = {
    enable = mkEnableOption "laptop";
  };

  config = mkIf cfg.enable {
    system.nixos.tags = ["laptop"];
    powerManagement.enable = true;

    # environment.systemPackages = [inputs.nbfc-linux.packages."${pkgs.system}".default];

    home-manager.users.tomas.programs.gnome-shell.extensions = with pkgs.gnomeExtensions; (
      optional
      (!config.trait.hardware.laptop.thinkpad.enable)
      {package = battery-health-charging;}
    );

    boot = {
      kernelModules = ["acpi_call"];
      extraModulePackages = with config.boot.kernelPackages; [acpi_call];
    };

    systemd.services."beesd@root" = {
      unitConfig = {
        ConditionACPower = true;
      };
      wantedBy = ["acpower.target"];
      partOf = ["acpower.target"];
    };
    systemd.services."nh-clean" = {
      unitConfig = {
        ConditionACPower = true;
      };
      wantedBy = ["acpower.target"];
      partOf = ["acpower.target"];
    };
    systemd.services."nix-optimise" = {
      unitConfig = {
        ConditionACPower = true;
      };
      wantedBy = ["acpower.target"];
      partOf = ["acpower.target"];
    };

    boot.kernelParams = [
      "ahci.mobile_lpm_policy=3"
      "rtc_cmos.use_acpi_alarm=1"
    ];

    services = {
      # synergy.server = {
      #   enable = true;
      # };

      udev.extraRules = ''
        SUBSYSTEM=="power_supply", KERNEL=="AC", ATTR{online}=="0", RUN+="${pkgs.systemd}/bin/systemctl start battery.target"
        SUBSYSTEM=="power_supply", KERNEL=="AC", ATTR{online}=="1", RUN+="${pkgs.systemd}/bin/systemctl stop battery.target"
        SUBSYSTEM=="power_supply", KERNEL=="AC", ATTR{online}=="1", RUN+="${pkgs.systemd}/bin/systemctl start acpower.target"
        SUBSYSTEM=="power_supply", KERNEL=="AC", ATTR{online}=="0", RUN+="${pkgs.systemd}/bin/systemctl stop acpower.target"
      '';

      thermald.enable = true;

      # xrdp.enable = mkForce false;

      tlp.enable = true;
      power-profiles-daemon.enable = false;

      acpid = {
        enable = true;
        logEvents = true;

        # acEventCommands = ''
        #   case "$@" in
        #     *00000001)
        #       systemctl start beesd@root.service
        #       ;;

        #     *00000000)
        #       systemctl stop beesd@root.service
        #       ;;
        #   esac
        # '';
      };
    };

    systemd.targets = {
      sleep.enable = true;
      suspend.enable = true;
      hibernate.enable = true;
      hybrid-sleep.enable = true;
      battery = {
        enable = true;
        unitConfig = {
          DefaultDependencies = "no";
          StopWhenUnneeded = "yes";
        };
      };
      acpower = {
        enable = true;
        unitConfig = {
          DefaultDependencies = "no";
          StopWhenUnneeded = "yes";
        };
      };
    };
  };
}
