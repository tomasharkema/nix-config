{
  pkgs,
  inputs,
  lib,
  ...
}:
with lib; {
  imports = with inputs; [
    "${nixpkgs}/nixos/modules/profiles/qemu-guest.nix"
    ./hardware-configuration.nix
  ];

  config = {
    age.rekey = {
      hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJvvDPvcdtTqOqKdAc5ixilJjQYGJFamhVLN6cjn67wz root@euro-mir-vm";
    };

    # nixpkgs.crossSystem.system = "aarch64-linux";
    networking = {
      wireless.enable = mkForce false;
      hostName = "euro-mir-vm";
    };

    users.mutableUsers = true;

    time.timeZone = "Europe/Amsterdam";

    disks.ext4 = {
      enable = true;
      main = "/dev/vda";
      encrypt = false;
    };

    boot = {
      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
      };
      kernelModules = ["virtio_gpu"];
    };

    # virtualisation.rosetta.enable = true;

    # fileSystems = {
    #   "/" = {
    #     device = "/dev/nvme0n1";
    #     fsType = "ext4";
    #   };
    #   "/boot" = {
    #     device = "/dev/vda1";
    #     fsType = "vfat";
    #     options = [
    #       "fmask=0022"
    #       "dmask=0022"
    #     ];
    #   };
    # };

    gui = {
      enable = true;
      desktop = {enable = true;};
      quiet-boot.enable = false;
      gnome.enable = true;
    };

    apps = {
      flatpak.enable = true;
      # opensnitch.enable = true;
      ancs4linux.enable = false;
    };

    boot = {
      growPartition = mkDefault false;

      tmp = {
        useTmpfs = false;
        cleanOnBoot = false;
      };
      recovery = {
        enable = false;
      };
    };
    trait = {
      developer.enable = false;
      hardware = {
        tpm.enable = false;
        secure-boot.enable = false;
        vm.enable = true;
        remote-unlock.enable = false;
      };
    };
    resilio.enable = false;

    hardware.graphics = {
      enable = true;
    };

    zramSwap.enable = false;

    services = {
      remote-builders.client.enable = true;
      #      kmscon.enable = false;
      upower.enable = mkForce false;
      auto-cpufreq.enable = mkForce false;
      monit.enable = mkForce false;
      # tor.enable = false;
      # xrdp.enable = mkForce false;
      fwupd.enable = mkForce false;

      # spice-autorandr.enable = true;
      spice-vdagentd.enable = true;
      spice-webdavd.enable = true;
      qemuGuest.enable = true;
    };
  };
}
