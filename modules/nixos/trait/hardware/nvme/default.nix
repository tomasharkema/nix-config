{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.trait.hardware.nvme;
in {
  options.trait.hardware.nvme = {
    enable = mkEnableOption "nvme";
  };

  config = mkIf cfg.enable {
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
