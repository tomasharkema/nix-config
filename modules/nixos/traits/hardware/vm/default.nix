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
      enable = mkBoolOpt false "hardware vm";
    };
  };

  config = mkIf cfg.enable {
    # traits.slim.enable = true;

    services = {
      # xserver.videoDrivers = [ "qxl" ];
      qemuGuest.enable = true;
      spice-vdagentd.enable = true;
      spice-autorandr.enable = mkIf pkgs.stdenv.isx86_64 true;
      spice-webdavd.enable = true;
      throttled.enable = mkForce false;
    };

    nix.settings = {
      keep-outputs = mkForce false;
      keep-derivations = mkForce false;
    };

    hardware = {
      cpu.intel.updateMicrocode = false;
      enableRedistributableFirmware = false;
      enableAllFirmware = false;
    };
    resilio.enable = false;

    boot = {
      # availableKernelModules = ["virtio_net" "virtio_pci" "virtio_mmio" "virtio_blk" "virtio_scsi" "9p" "9pnet_virtio"];
      # kernelModules = [
      #   "virtio_balloon"
      #   "virtio_console"
      #   "virtio_rng"
      # ];

      initrd = {
        # availableKernelModules = [
        #   "virtio_net"
        #   "virtio_pci"
        #   "virtio_mmio"
        #   "virtio_blk"
        #   "virtio_scsi"
        #   "9p"
        #   "9pnet_virtio"
        # ];
        # kernelModules = [
        #   "virtio_balloon"
        #   "virtio_console"
        #   "virtio_rng"
        # ];
      };
    };
  };
}
