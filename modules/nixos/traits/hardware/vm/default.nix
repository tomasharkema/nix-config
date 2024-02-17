{
  config,
  pkgs,
  lib,
  modulesPath,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.traits.hardware.vm;
in {
  options.traits.hardware = {
    vm = {
      enable = mkBoolOpt false "SnowflakeOS GNOME configuration";
    };
  };

  config = mkIf cfg.enable {
    services = {
      xserver.videoDrivers = ["qxl"];
      qemuGuest.enable = true;
      spice-vdagentd.enable = true;
      spice-autorandr.enable = mkIf pkgs.stdenv.isx86_64 true;
      spice-webdavd.enable = true;
    };
    # powerManagement.powertop.enable = false;
    hardware = {
      cpu.intel.updateMicrocode = false;
      enableRedistributableFirmware = false;
      enableAllFirmware = false;
    };
    resilio.enable = false;
  };
}
