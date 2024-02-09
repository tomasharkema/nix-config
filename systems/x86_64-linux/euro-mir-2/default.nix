{
  pkgs,
  inputs,
  config,
  ...
}: {
  imports = with inputs; [
    nixos-hardware.nixosModules.dell-xps-15-9560-nvidia
    ./hardware-configuration.nix
  ];

  config = {
    disks.btrfs = {
      enable = true;
      main = "/dev/nvme0n1";
      encrypt = true;
    };

    gui = {
      enable = true;
      desktop = {
        enable = true;
      };
      gnome.enable = true;
      # game-mode.enable = true;
      quiet-boot.enable = true;
    };

    apps = {
      podman.enable = true;
      android.enable = true;
      steam.enable = true;
    };

    headless.hypervisor.enable = true;

    traits = {
      hardware = {
        tpm.enable = true;
        secure-boot.enable = true;
        laptop.enable = true;
        nvidia.enable = true;
        # remote-unlock.enable = true;
      };
    };

    networking = {
      hostName = "euro-mir-2"; # Define your hostname.
      networkmanager.enable = true;
      # wireless.enable = true;
      firewall.enable = true;
    };

    services = {
      # fprintd = {
      #   enable = true;
      #   package = pkgs.fprintd-tod;
      #   tod = {
      #     enable = true;
      #     driver = pkgs.libfprint-2-tod1-goodix-550a;
      #   };
      # };
    };

    boot = {
      binfmt.emulatedSystems = ["aarch64-linux"];
      kernelParams = ["acpi_rev_override=1"];
      extraModprobeConfig = "options kvm_intel nested=1";
    };

    programs = {
      mtr.enable = true;
    };
  };
}
