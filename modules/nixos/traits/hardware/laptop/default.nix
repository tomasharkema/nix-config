{
  lib,
  config,
  inputs,
  pkgs,
  ...
}:
with lib; let
  cfg = config.traits.hardware.laptop;
in {
  options.traits = {
    hardware.laptop = {
      enable = mkEnableOption "laptop";
    };
  };

  config = mkIf cfg.enable {
    system.nixos.tags = ["laptop"];
    powerManagement.enable = true;

    # environment.systemPackages = [inputs.nbfc-linux.packages."${pkgs.system}".default];

    home-manager.users.tomas.programs.gnome-shell.extensions = with pkgs.gnomeExtensions; (
      optional
      (!config.traits.hardware.laptop.thinkpad.enable)
      {package = battery-health-charging;}
    );

    boot = {
      kernelModules = ["acpi_call"];
      extraModulePackages = with config.boot.kernelPackages; [acpi_call];
    };

    services = {
      # synergy.server = {
      #   enable = true;
      # };

      thermald.enable = true;

      xrdp.enable = mkForce false;

      tlp.enable = true;
      power-profiles-daemon.enable = false;
    };

    systemd.targets = {
      sleep.enable = true;
      suspend.enable = true;
      hibernate.enable = true;
      hybrid-sleep.enable = true;
    };
  };
}
