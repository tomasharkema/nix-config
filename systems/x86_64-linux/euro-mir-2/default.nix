{ pkgs, inputs, config, lib, ... }:
with lib; {
  imports = with inputs; [
    nixos-hardware.nixosModules.dell-xps-15-9570-nvidia
    ./hardware-configuration.nix
  ];

  config = {

    disks.btrfs = {
      enable = true;
      main = "/dev/nvme0n1";
      encrypt = true;
      newSubvolumes = true;
    };

    environment.systemPackages = with pkgs; [
      davinci-resolve
      bolt
      # calibre
      glxinfo
      inxi
      pkgs.gnomeExtensions.battery-health-charging

      mpv
      mpvc
      play-with-mpv

      plex-mpv-shim
      open-in-mpv
      celluloid
      pwvucontrol
    ];

    home-manager.users.tomas.dconf.settings."org/gnome/shell".enabled-extensions =
      [ "Battery-Health-Charging@maniacx.github.com" ];

    gui = {
      enable = true;
      desktop = { enable = true; };
      gnome.enable = true;
      gamemode.enable = true;
      quiet-boot.enable = true;
    };

    environment.enableDebugInfo = true;

    hardware = {
      nvidia = {
        # nvidiaPersistenced = true; 
        prime = {
          sync.enable = true;
          offload.enable = false;
          offload.enableOffloadCmd = false;
        };
      };
      # fancontrol.enable = true;
      opengl = {
        extraPackages = with pkgs; [
          vaapiIntel
          libvdpau-va-gl
          vaapiVdpau
          intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
        ];
      };
    };

    # environment.variables = {
    #   GDK_SCALE = "2";
    #   GDK_DPI_SCALE = "0.5";
    #   QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    # };

    # services.xserver.dpi = 227;

    apps = {
      # android.enable = true;
      steam.enable = true;
      # opensnitch.enable = true;
      usbip.enable = true;
    };

    headless.hypervisor = {
      enable = true;
      #   bridgeInterfaces = ["wlp59s0"];
    };
    # virtualisation.waydroid.enable = true;
    traits = {
      hardware = {
        tpm.enable = true;
        secure-boot.enable = true;
        laptop.enable = true;
        nvidia.enable = true;
        # remote-unlock.enable = true;
        bluetooth.enable = true;
      };
    };

    networking = {
      hostName = "euro-mir-2"; # Define your hostname.
      networkmanager.enable = true;
      # wireless.enable = true;
      firewall.enable = false;
    };

    apps.podman.enable = true;

    services = {
      # usb-over-ethernet.enable = true;
      hardware.bolt.enable = true;
      beesd.filesystems = {
        root = {
          spec = "UUID=3e30181c-9df4-4412-a1ee-cb97819f218c";
          hashTableSizeMB = 4096;
          verbosity = "crit";
          extraOptions = [ "--loadavg-target" "2.0" ];
        };
      };
      # synergy.server = {
      #   enable = true;
      # };

      avahi = {
        enable = true;
        allowInterfaces = [ "wlp59s0" ];
        reflector = mkForce false;
      };

      fprintd = {
        enable = true;
        package = pkgs.fprintd-tod;
        tod = {
          enable = true;

          #     # driver = pkgs.libfprint-2-tod1-goodix;
          driver = pkgs.libfprint-2-tod1-goodix-550a;
        };
      };
    };

    boot = {
      binfmt.emulatedSystems = [ "aarch64-linux" ];
      # extraModprobeConfig = ''
      #   options nvidia NVreg_DynamicPowerManagement=0x02
      #   options nvidia NVreg_PreserveVideoMemoryAllocations=1
      # '';
      supportedFilesystems = [ "ntfs" ];
      kernelModules = [ "kvm-intel" ];
    };
  };
}
