{
  pkgs,
  inputs,
  config,
  lib,
  ...
}: {
  imports = with inputs; [
    nvidia-vgpu-nixos.nixosModules.guest
  ];

  config = {
    nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

    age.rekey = {
      hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDC7tNpEvVh4rd5ChYh2uTRK/cMRes21NW8HiZQc0vo5 root@test";
    };

    system.build.guestDriver = config.boot.kernelPackages.nvidiaPackages.grid_17_3;

    disks.ext4 = {
      enable = true;
      main = "/dev/vda";
    };

    services = {
      kmscon.enable = lib.mkForce false;
      resilio.enable = lib.mkForce false;

      xserver.videoDrivers = ["nvidia"];
    };

    traits = {hardware.vm.enable = true;};

    networking = {
      hostName = "test";
    };
    boot = {
      kernelPackages = pkgs.linuxPackages_6_12;
    };

    virtualisation.vmVariant = {
      # following configuration is added only when building VM with build-vm
      virtualisation = {
        memorySize = 4096;
        cores = 4;
      };
    };
  };
}
