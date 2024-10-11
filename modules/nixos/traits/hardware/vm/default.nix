{
  config,
  pkgs,
  lib,
  modulesPath,
  ...
}: let
  cfg = config.traits.hardware.vm;
in {
  options.traits.hardware.vm = {
    enable = lib.mkEnableOption "hardware vm";
  };

  config = lib.mkIf cfg.enable {
    # .slim.enable = true;

    services = {
      # xserver.videoDrivers = [ "qxl" ];
      qemuGuest.enable = true;
      spice-vdagentd.enable = true;
      spice-autorandr.enable = lib.mkIf pkgs.stdenv.isx86_64 true;
      spice-webdavd.enable = true;
      throttled.enable = lib.mkForce false;
    };

    nix.settings = {
      keep-outputs = lib.mkForce false;
      keep-derivations = lib.mkForce false;
    };

    hardware = {
      cpu.intel.updateMicrocode = false;
      enableRedistributableFirmware = false;
      enableAllFirmware = false;
    };
    apps.resilio.enable = false;

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
