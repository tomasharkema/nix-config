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

    environment.systemPackages = with pkgs; [
      bolt
      # calibre
      glxinfo
      inxi
      linuxPackages.usbip
    ];

    gui = {
      enable = true;
      desktop = {
        enable = true;
      };
      gnome.enable = true;
      gamemode.enable = true;
      quiet-boot.enable = true;
    };

    environment.enableDebugInfo = true;

    hardware = {
      nvidia = {
        nvidiaPersistenced = false;
        # dynamicBoost.enable = true;
        prime = {
          sync.enable = true;
          offload.enable = false;
          offload.enableOffloadCmd = false;
        };
      };
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
      hardware.bolt.enable = true;
      beesd.filesystems = {
        root = {
          spec = "UUID=3e30181c-9df4-4412-a1ee-cb97819f218c";
          hashTableSizeMB = 4096;
          verbosity = "crit";
          extraOptions = ["--loadavg-target" "2.0"];
        };
      };
      synergy.server = {
        enable = true;
      };

      avahi = {
        enable = true;
        allowInterfaces = ["wlp59s0"];
        reflector = mkForce false;
      };

      fprintd = {
        enable = true;
        package = pkgs.fprintd-tod;
        tod = {
          enable = true;
          # driver = pkgs.custom.libfprint-2-tod1-goodix;
          driver = pkgs.libfprint-2-tod1-goodix;
        };
      };
    };

    boot = {
      binfmt.emulatedSystems = ["aarch64-linux"];
      extraModprobeConfig = ''
        options nvidia NVreg_DynamicPowerManagement=0x02
        options nvidia NVreg_PreserveVideoMemoryAllocations=1
      '';
      supportedFilesystems = ["ntfs"];
      kernelModules = ["vhci-hcd" "usbip_host" "usbip_core"];
      tmp = {
        useTmpfs = false;
        cleanOnBoot = true;
      };
    };
  };
}
