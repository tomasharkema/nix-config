{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.trait.hardware.nvme;
in {
  options.trait.hardware.nvme = {
    enable = lib.mkEnableOption "nvme";
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [nvme-cli];

    boot = {
      initrd.availableKernelModules = [
        "nvme"
      ];
      kernelModules = [
        "nvme"
      ];
    };
  };
}
