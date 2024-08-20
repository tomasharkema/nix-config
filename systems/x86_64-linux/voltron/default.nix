{
  pkgs,
  inputs,
  config,
  lib,
  ...
}:
with lib; {
  imports = with inputs; [
    ./hardware-configuration.nix
    nixos-hardware.nixosModules.common-pc-laptop-acpi_call
    nixos-hardware.nixosModules.common-cpu-intel
    nixos-hardware.nixosModules.common-gpu-intel
    nixos-hardware.nixosModules.common-gpu-intel-kaby-lake
  ];

  config = {
    age = {
      rekey = {
        hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHsy1IFC8nJp/gFmti2VMz5/pqnY8mZRazM960EhcC4O root@voltron";
      };
    };

    disks.btrfs = {
      enable = true;
      main = "/dev/nvme0n1";
      encrypt = true;
      newSubvolumes = true;
      btrbk.enable = true;
      snapper.enable = false;
    };

    programs.gnupg.agent = {enable = true;};

    services = {
      # dbus.packages = with pkgs; [custom.ancs4linux];

      udev = {
        enable = true;
        packages = with pkgs; [heimdall-gui libusb sgx-psw];
      };

      # fprintd.tod.driver = inputs.nixos-06cb-009a-fingerprint-sensor.lib.libfprint-2-tod1-vfs0090-bingch {
      #   calib-data-file = ./calib-data.bin;
      # };
    };

    environment.systemPackages = with pkgs; [
      nvramtool
      libusb
      sgx-psw

      gnupg
      custom.distrib-dl
      # davinci-resolve
      keybase-gui
      # calibre
      glxinfo
      inxi
      pwvucontrol
    ];

    gui = {
      enable = true;
      desktop = {enable = true;};
      gnome = {
        enable = true;
        # hidpi.enable = true;
      };
      gamemode.enable = true;
      quiet-boot.enable = true;
    };

    hardware = {
      nvidia = {
        # forceFullCompositionPipeline = true;

        prime = {
          sync.enable = true;
          offload.enable = false;
          offload.enableOffloadCmd = false;
          intelBusId = "PCI:0:2:0";
          nvidiaBusId = "PCI:02:0:0";
        };
        # powerManagement = {
        #   enable = true;
        #   finegrained = true;
        # };
      };
      # fancontrol.enable = true;
      graphics = {
        extraPackages = with pkgs; [
          vaapiIntel
          libvdpau-va-gl
          vaapiVdpau
          intel-media-driver
          vpl-gpu-rt
        ];
      };
    };

    apps = {
      # android.enable = true;
      steam.enable = true;
      opensnitch.enable = true;
      # usbip.enable = true;
      # samsung.enable = true;
    };

    trait = {
      hardware = {
        nvme.enable = true;
        tpm.enable = true;
        secure-boot.enable = true;
        laptop.enable = true;
        laptop.thinkpad.enable = true;
        nvidia.enable = true;
        # remote-unlock.enable = true;
        bluetooth.enable = true;
        monitor.enable = true;
      };
    };

    networking = {
      hostName = "voltron"; # Define your hostname.
      networkmanager.enable = true;
      # wireless.enable = true;
      firewall = {
        enable = true;

        trustedInterfaces = ["virbr0" "virbr1" "vnet0"];
      };
    };

    apps.podman.enable = true;

    services = {
      journald.storag = "volatile";

      hypervisor = {
        enable = true;
        #   bridgeInterfaces = ["wlp59s0"];
      };
      # remote-builders.client.enable = true;
      # usb-over-ethernet.enable = true;
      hardware.bolt.enable = true;
      beesd.filesystems = {
        root = {
          spec = "UUID=22a02900-5321-481c-af47-ff8700570cc6";
          hashTableSizeMB = 4096;
          verbosity = "crit";
          extraOptions = ["--loadavg-target" "2.0"];
        };
      };

      avahi = {
        enable = true;
        # allowInterfaces = ["wlp59s0"];
        reflector = mkForce false;
      };

      # aesmd = {
      # enable = true;
      # settings = {
      # defaultQuotingType = "ecdsa_256";
      # whitelistUrl = "http://whitelist.trustedservices.intel.com/SGX/LCWL/Linux/sgx_white_list_cert.bin";
      # };
      # };
    };

    # hardware.nvidia.vgpu = {
    #   enable = true;
    #   unlock.enable = true;
    #   version = "v17.1";
    # };

    # system.build.isgx = config.boot.kernelPackages.isgx.overrideAttrs (prev: {
    #   patches =
    #     (prev.patches or [])
    #     ++ [
    #       ./157.patch
    #     ];
    # });

    users = {
      users.tomas.extraGroups = ["sgx_prv"];
    };

    boot = {
      # resumeDevice = "/dev/disk/by-partlabel/disk-main-swap";

      tmp = {
        useTmpfs = false;
      };

      # recovery = {
      #   enable = true;
      #   install = true;
      #   sign = true;
      #   netboot.enable = true;
      # };

      # binfmt.emulatedSystems = ["aarch64-linux"];

      # modprobeConfig.enable = true;

      # extraModprobeConfig = [];
      kernelParams = [
        "nowatchdog"
        # "mitigations=off"
      ];

      # extraModulePackages = [
      #   config.system.build.isgx
      # ];

      kernelModules = [
        "i915"
        "isgx"
        # "watchdog"
        #"tpm_rng"
      ];
      extraModprobeConfig = "options i915 enable_guc=2";
      initrd.kernelModules = [
        #  "watchdog"
        # "isgx"
      ];
    };
  };
}
