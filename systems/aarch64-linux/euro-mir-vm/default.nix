{ pkgs, inputs, lib, ... }:
with lib; {
  imports = with inputs; [
    "${nixpkgs}/nixos/modules/profiles/qemu-guest.nix"
    ./hardware-configuration.nix
  ];

  config = {
    # nixpkgs.crossSystem.system = "aarch64-linux";
    networking = {
      wireless.enable = mkForce false;
      hostName = "euro-mir-vm";
    };

    users.mutableUsers = true;

    time.timeZone = "Europe/Amsterdam";

    # disks.btrfs = {
    #   enable = true;
    #   main = "/dev/vda";
    #   encrypt = false;
    #   newSubvolumes = true;
    # };

    disks.ext4 = {
      enable = true;
      main = "/dev/nvme0n1";
      encrypt = false;
    };

    boot = {
      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };
      kernelModules = [ "virtio_gpu" ];
    };

    virtualisation.rosetta.enable = true;

    # fileSystems."/" = {
    #   device = "/dev/disk/by-uuid/fd0e4d0a-b101-4c92-9dee-c9b4ee171836";
    #   fsType = "ext4";
    # };

    fileSystems."/boot" = {
      #   device = "/dev/disk/by-uuid/A6D4-8A1F";
      #   fsType = "vfat";
      options = [ "fmask=0022" "dmask=0022" ];
    };

    gui = {
      enable = true;
      desktop = { enable = true; };
      quiet-boot.enable = true;
      gnome.enable = true;
    };

    apps = {
      flatpak.enable = true;
      # opensnitch.enable = true;
      remote-builders.enable = true;
    };

    boot = {
      growPartition = mkDefault false;

      tmp = {
        useTmpfs = false;
        cleanOnBoot = false;
      };
    };
    traits = {
      developer.enable = false;
      hardware = {
        tpm.enable = false;
        secure-boot.enable = false;
        vm.enable = true;
        remote-unlock.enable = false;
      };
    };
    resilio.enable = false;

    hardware.opengl = {
      enable = true;
      driSupport = true;
      #   # driSupport32Bit = true;
    };

    zramSwap.enable = false;

    services = mkForce {
      kmscon.enable = false;
      upower.enable = false;
      auto-cpufreq.enable = false;
      monit.enable = false;
      tor.enable = false;
      udisks2.enable = false;
      xrdp.enable = false;
      fwupd.enable = false;

      # spice-autorandr.enable = true;
      spice-vdagentd.enable = true;
      spice-webdavd.enable = true;
      qemuGuest.enable = true;
    };
  };
}
