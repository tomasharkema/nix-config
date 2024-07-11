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
  ];

  config = {
    age = {
      rekey = {
        hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIImcDgt9Pzve8g2auikBFQ3JkXB5UqoRfr7D22caGMgB root@voltron";
      };

      secrets = {
        "calib-data" = {
          rekeyFile = ./calib-data.age;
        };
      };
    };

    disks.btrfs = {
      enable = true;
      main = "/dev/nvme0n1";
      encrypt = true;
      newSubvolumes = true;
      btrbk.enable = true;
    };

    programs.gnupg.agent = {enable = true;};

    services = {
      dbus.packages = with pkgs; [custom.ancs4linux];

      udev = {
        enable = true;
        packages = with pkgs; [heimdall-gui libusb];
      };

      fprintd = {
        enable = true;
        tod = {
          enable = true;
          driver = inputs.nixos-06cb-009a-fingerprint-sensor.lib.libfprint-2-tod1-vfs0090-bingch {
            calib-data-file = config.age.secrets."calib-data".path; #./calib-data.bin;
          };
        };
      };
    };

    home-manager.users.tomas.programs.gnome-shell.extensions = with pkgs.gnomeExtensions; [
      {package = thinkpad-thermal;}
      {package = fnlock-switch-thinkpad-compact-usb-keyboard;}
    ];

    security.pam.services."gdm-fingerprint".enableGnomeKeyring = true;

    age.secrets."calib-data" = {
      file = ../../../secrets/calib-data.age;
      # owner = "tomas";
      # group = "tomas";
      mode = "666";
      # symlink = false;
    };

    environment.systemPackages = with pkgs; [
      libusb
      tp-auto-kbbl
      modemmanager
      modem-manager-gui
      libmbim
      libqmi

      thinkfan

      tpacpi-bat

      ventoy-full
      gnupg
      custom.distrib-dl
      custom.ancs4linux
      davinci-resolve
      bolt
      # calibre
      glxinfo
      inxi

      pwvucontrol
    ];

    # home-manager.users.tomas.dconf.settings."org/gnome/shell".enabled-extensions = ["Battery-Health-Charging@maniacx.github.com"];

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
        forceFullCompositionPipeline = true;

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
      opengl = {
        extraPackages = with pkgs; [
          vaapiIntel
          libvdpau-va-gl
          vaapiVdpau
          intel-vaapi-driver # LIBVA_DRIVER_NAME=i965 (older but works better for Firefox/Chromium)
        ];
      };
    };

    apps = {
      # android.enable = true;
      steam.enable = true;
      # opensnitch.enable = true;
      # usbip.enable = true;
      samsung.enable = true;
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

      # synergy.server = {
      #   enable = true;
      # };

      avahi = {
        enable = true;
        # allowInterfaces = ["wlp59s0"];
        reflector = mkForce false;
      };
    };

    security.pam.services = {
      xscreensaver.fprintAuth = true;
      login.fprintAuth = true;
    };

    boot = {
      binfmt.emulatedSystems = ["aarch64-linux"];

      modprobeConfig.enable = true;
      extraModprobeConfig = ''
        options thinkpad_acpi fan_control=1
      '';

      kernelModules = [
        "kvm-intel"
        "thinkpad_acpi"
        # "watchdog"
      ];
      initrd.kernelModules = [
        #  "watchdog"
      ];
    };
  };
}
