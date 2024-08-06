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

    systemd.services."beesd@root".unitConfig.ConditionACPower = true;
    systemd.services."nh-clean".unitConfig.ConditionACPower = true;
    systemd.services."nix-optimise".unitConfig.ConditionACPower = true;

    services = {
      # synergy.server = {
      #   enable = true;
      # };

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
    };
  };
}
