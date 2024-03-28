{
  pkgs,
  inputs,
  config,
  lib,
  ...
}:
with lib; {
  imports = with inputs; [
    nixos-hardware.nixosModules.dell-xps-15-9570-nvidia
    ./hardware-configuration.nix
  ];

  config = {
    installed = true;
    disks.btrfs = {
      enable = true;
      main = "/dev/nvme0n1";
      encrypt = true;
      newSubvolumes = true;
    };

    services.hardware.bolt.enable = true;

    environment.systemPackages = with pkgs; [bolt];

    gui = {
      enable = true;
      desktop = {
        enable = true;
      };
      gnome.enable = true;
      game-mode.enable = true;
      quiet-boot.enable = true;
    };

    hardware = {
      nvidia.nvidiaPersistenced = false;
      # fancontrol.enable = true;
      opengl = {
        extraPackages = with pkgs; [vaapiIntel libvdpau-va-gl vaapiVdpau];
      };
    };

    apps = {
      # android.enable = true;
      steam.enable = true;
      # opensnitch.enable = true;
    };

    headless.hypervisor = {
      enable = true;
      #   bridgeInterfaces = ["wlp59s0"];
    };

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
      firewall.enable = false;
    };

    services = {
      # podman.enable = true;

      synergy.server = {
        enable = true;
      };

      avahi = {
        enable = true;
        allowInterfaces = ["wlp59s0"];
        reflector = mkForce false;
      };

      # fprintd = {
      #   enable = true;
      #   package = pkgs.fprintd-tod;
      #   tod = {
      #     enable = true;
      #     driver = pkgs.custom.libfprint-2-tod1-goodix; #pkgs.libfprint-2-tod1-goodix;
      #   };
      # };
    };

    # services.fprintd = let
    #   libfprint-tod = pkgs.libfprint.overrideAttrs (_: rec {
    #     pname = "libfprint-tod";
    #     version = "1.94.7+tod1";
    #     src = pkgs.fetchFromGitLab {
    #       domain = "gitlab.freedesktop.org";
    #       owner = "3v1n0";
    #       repo = "libfprint";
    #       rev = "v${version}";
    #       sha256 = "sha256-q6m/J5GH86/z/mKnrYoanhKWR7+reKIRHqhDOUkknFA=";
    #     };
    #     doCheck = false;
    #   });
    # in {
    #   enable = true;
    #   package = pkgs.fprintd.override {libfprint = libfprint-tod;};
    #   tod = {
    #     enable = true;
    #     driver = pkgs.libfprint-2-tod1-goodix.override {libfprint-tod = libfprint-tod;};
    #   };
    # };
    # systemd.services."fprintd".environment."G_MESSAGES_DEBUG" = "all"; # for good measure

    boot = {
      binfmt.emulatedSystems = ["aarch64-linux"];
      kernelParams = ["acpi_rev_override=1"];
    };

    programs = {
      mtr.enable = true;
    };
  };
}
