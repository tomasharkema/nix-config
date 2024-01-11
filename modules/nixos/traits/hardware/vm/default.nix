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

  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  config = mkIf cfg.enable {
    services = {
      xserver.videoDrivers = ["qxl"];
      qemuGuest.enable = true;
      spice-vdagentd.enable = true;
    };
  };
}
