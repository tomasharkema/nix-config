{ config, pkgs, lib, modulesPath, ... }:
with lib;
with lib.custom;
let cfg = config.traits.hardware.vm;
in {
  options.traits.hardware = {
    vm = { enable = mkBoolOpt false "hardware vm"; };
  };

  config = mkIf cfg.enable {
    services = {
      xserver.videoDrivers = [ "qxl" ];
      qemuGuest.enable = true;
      spice-vdagentd.enable = true;
      spice-autorandr.enable = mkIf pkgs.stdenv.isx86_64 true;
      spice-webdavd.enable = true;
      throttled.enable = mkForce false;
    };

    hardware = {
      cpu.intel.updateMicrocode = false;
      enableRedistributableFirmware = false;
      enableAllFirmware = false;
    };
    resilio.enable = false;

    boot = {
      # availableKernelModules = ["virtio_net" "virtio_pci" "virtio_mmio" "virtio_blk" "virtio_scsi" "9p" "9pnet_virtio"];
      kernelModules = [ "virtio_balloon" "virtio_console" "virtio_rng" ];

      initrd = {
        availableKernelModules = [
          "virtio_net"
          "virtio_pci"
          "virtio_mmio"
          "virtio_blk"
          "virtio_scsi"
          "9p"
          "9pnet_virtio"
        ];
        kernelModules = [ "virtio_balloon" "virtio_console" "virtio_rng" ];

        postDeviceCommands = lib.mkIf (!config.boot.initrd.systemd.enable) ''
          # Set the system time from the hardware clock to work around a
          # bug in qemu-kvm > 1.5.2 (where the VM clock is initialised
          # to the *boot time* of the host).
          hwclock -s
        '';
      };
    };
  };
}
