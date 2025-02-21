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

    boot = {
      # kernelModules = ["acpi_call"];
      # extraModulePackages = with config.boot.kernelPackages; [acpi_call];
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

      # tlp.enable = true;
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
              ${ppd} set performance
             ;;
          esac
        '';
      };
    };
  };
}
