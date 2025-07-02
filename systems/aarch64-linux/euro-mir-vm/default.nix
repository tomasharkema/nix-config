{
  pkgs,
  inputs,
  lib,
  ...
}: {
  imports = with inputs; [
    "${nixpkgs}/nixos/modules/profiles/qemu-guest.nix"
    ./hardware-configuration.nix
  ];

  config = {
    age.rekey = {
      hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMkPlI0DLWGqTA6VKzEUjKYFyPmMn+gHhhDkZLRZRe5q root@euro-mir-vm";
    };

    # nixpkgs.crossSystem.system = "aarch64-linux";
    networking = {
      wireless.enable = lib.mkForce false;
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
      docker.enable = true;
    };

    boot = {
      # growPartition = true;

      tmp = {
        useTmpfs = false;
        cleanOnBoot = true;
      };
      recovery = {
        enable = false;
      };
    };
    traits = {
      developer.enable = false;
      hardware = {
        tpm.enable = true;
        secure-boot.enable = false;
        vm.enable = true;
        remote-unlock.enable = false;
      };
    };
    apps.resilio.enable = false;

    hardware.graphics = {
      enable = true;
    };

    zramSwap.enable = false;

    services = {
      remote-builders.client.enable = true;
      #      kmscon.enable = false;
      upower.enable = lib.mkForce false;
      auto-cpufreq.enable = lib.mkForce false;
      monit.enable = lib.mkForce false;
      # tor.enable = false;
      # xrdp.enable = lib.mkForce false;
      fwupd.enable = lib.mkForce false;

      # spice-autorandr.enable = true;
      spice-vdagentd.enable = true;
      spice-webdavd.enable = true;
      qemuGuest.enable = true;
    };
  };
}
