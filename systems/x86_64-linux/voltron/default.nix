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

    nixos-06cb-009a-fingerprint-sensor.nixosModules.open-fprintd
    nixos-06cb-009a-fingerprint-sensor.nixosModules.python-validity

    nixos-hardware.nixosModules.common-pc-laptop-acpi_call
    nixos-hardware.nixosModules.common-cpu-intel
    nixos-hardware.nixosModules.common-gpu-intel
    nixos-hardware.nixosModules.common-gpu-intel-kaby-lake
  ];

  config = {
    age = {
      rekey = {
        hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIImcDgt9Pzve8g2auikBFQ3JkXB5UqoRfr7D22caGMgB root@voltron";
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
      # dbus.packages = with pkgs; [custom.ancs4linux];

      udev = {
        enable = true;
        packages = with pkgs; [heimdall-gui libusb];
      };

      # fprintd = {
      #   enable = true;
      #   tod = {
      #     enable = true;
      #     driver = inputs.nixos-06cb-009a-fingerprint-sensor.lib.libfprint-2-tod1-vfs0090-bingch {
      #       calib-data-file = ./calib-data.bin;
      #     };
      #   };
      # };
      open-fprintd.enable = true;
      python-validity.enable = true;
      fprintd.package = inputs.nixos-06cb-009a-fingerprint-sensor.localPackages.fprintd-clients;
    };

    home-manager.users.tomas.programs.gnome-shell.extensions = with pkgs.gnomeExtensions; [
      {package = thinkpad-thermal;}
      {package = fnlock-switch-thinkpad-compact-usb-keyboard;}
    ];

    environment.systemPackages = with pkgs; [
      libusb
      tp-auto-kbbl
      # modemmanager
      # modem-manager-gui
      # libmbim
      # libqmi
      thinkfan
      tpacpi-bat
      gnupg
      custom.distrib-dl
      davinci-resolve

      # calibre
      glxinfo
      inxi
      pwvucontrol
      sgx-ssl
      sgx-sdk
      sgx-psw
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
      # opengl = {
      #   extraPackages = with pkgs; [
      #     vaapiIntel
      #     libvdpau-va-gl
      #     vaapiVdpau
      #     intel-media-driver
      #   ];
      # };
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

    traits = {
      hardware = {
        tpm.enable = true;
        secure-boot.enable = true;
        laptop.enable = true;
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
      remote-builders.client.enable = true;
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
      aesmd.enable = true;
    };

    security.pam.services = {
      "gdm-fingerprint" = {
        enableGnomeKeyring = true;
        fprintAuth = true;
      };
      xscreensaver = {
        fprintAuth = true;
        #   text = ''

        #     # Account management.
        #     account sufficient ${pkgs.sssd}/lib/security/pam_sss.so # sss (order 10400)
        #     account required pam_unix.so # unix (order 10900)

        #     # Authentication management.
        #     auth sufficient pam_unix.so likeauth try_first_pass # unix (order 11500)
        #     auth sufficient ${inputs.nixos-06cb-009a-fingerprint-sensor.localPackages.fprintd-clients}/lib/security/pam_fprintd.so
        #     auth sufficient ${pkgs.sssd}/lib/security/pam_sss.so use_first_pass # sss (order 11900)
        #     auth required pam_deny.so # deny (order 12300)

        #     # Password management.
        #     password sufficient pam_unix.so nullok yescrypt # unix (order 10200)
        #     password sufficient ${pkgs.sssd}/lib/security/pam_sss.so # sss (order 11000)

        #     # Session management.
        #     session required pam_env.so conffile=/etc/pam/environment readenv=0 # env (order 10100)
        #     session required pam_unix.so # unix (order 10200)
        #     session optional ${pkgs.sssd}/lib/security/pam_sss.so # sss (order 11700)
        #     session required ${pkgs.linux-pam}/lib/security/pam_limits.so conf=/nix/store/41cmfs9dq5zx16q88qdb68qrgr7cjfwk-limits.conf # limits (order 12200)

        #   '';
      };
      sudo = {
        fprintAuth = true;
      };
      login = {
        fprintAuth = true;
        #   text = ''
        #     # Account management.
        #     account sufficient ${pkgs.sssd}/lib/security/pam_sss.so # sss (order 10400)
        #     account required pam_unix.so # unix (order 10900)

        #     # Authentication management.
        #     auth sufficient ${inputs.nixos-06cb-009a-fingerprint-sensor.localPackages.fprintd-clients}/lib/security/pam_fprintd.so # fprintd (order 11300)
        #     auth optional pam_unix.so likeauth nullok # unix-early (order 11500)
        #     auth optional ${pkgs.gnome.gnome-keyring}/lib/security/pam_gnome_keyring.so # gnome_keyring (order 12100)
        #     auth sufficient pam_unix.so likeauth nullok try_first_pass # unix (order 12800)
        #     auth sufficient ${pkgs.sssd}/lib/security/pam_sss.so use_first_pass # sss (order 13200)
        #     auth required pam_deny.so # deny (order 13600)

        #     # Password management.
        #     password sufficient pam_unix.so nullok yescrypt # unix (order 10200)
        #     password sufficient ${pkgs.sssd}/lib/security/pam_sss.so # sss (order 11000)
        #     password optional ${pkgs.gnome.gnome-keyring}/lib/security/pam_gnome_keyring.so use_authtok # gnome_keyring (order 11200)

        #     # Session management.
        #     session required pam_env.so conffile=/etc/pam/environment readenv=0 # env (order 10100)
        #     session required pam_unix.so # unix (order 10200)
        #     session required pam_loginuid.so # loginuid (order 10300)
        #     session required ${pkgs.linux-pam}/lib/security/pam_lastlog.so silent # lastlog (order 10700)
        #     session optional ${pkgs.sssd}/lib/security/pam_sss.so # sss (order 11700)
        #     session optional ${config.systemd.package}/lib/security/pam_systemd.so # systemd (order 12000)
        #     #session required ${pkgs.linux-pam}/lib/security/pam_limits.so conf=/nix/store/41cmfs9dq5zx16q88qdb68qrgr7cjfwk-limits.conf # limits (order 12200)
        #     session optional ${pkgs.gnome.gnome-keyring}/lib/security/pam_gnome_keyring.so auto_start # gnome_keyring (order 12600)
        #   '';
      };

      # gdm-fingerprint.text = ''
      #   auth       required                    pam_shells.so
      #   auth       requisite                   pam_nologin.so
      #   auth       requisite                   pam_faillock.so      preauth
      #   auth       sufficient                  ${inputs.nixos-06cb-009a-fingerprint-sensor.localPackages.fprintd-clients}/lib/security/pam_fprintd.so
      #   auth       required                    pam_env.so
      #   auth       [success=ok default=1]      ${pkgs.gnome.gdm}/lib/security/pam_gdm.so
      #   auth       optional                    ${pkgs.gnome.gnome-keyring}/lib/security/pam_gnome_keyring.so

      #   account    include                     login

      #   password   required                    pam_deny.so

      #   session    include                     login
      # '';
    };

    # hardware.nvidia.vgpu = {
    #   enable = true;
    #   unlock.enable = true;
    #   version = "v16.5";
    # };

    hardware.cpu.intel.sgx = {
      enableDcapCompat = true;
      provision = {
        enable = true;
      };
    };

    users.users.tomas.extraGroups = ["sgx" "sgx_prv"];

    boot = {
      recovery = {
        enable = true;
        install = true;
        sign = true;
        netboot.enable = true;
      };

      binfmt.emulatedSystems = ["aarch64-linux"];

      modprobeConfig.enable = true;
      extraModprobeConfig = ''
        options thinkpad_acpi fan_control=1
      '';
      # extraModulePackages = [config.boot.kernelPackages.isgx];
      kernelModules = [
        "isgx"
        "watchdog"
        #"tpm_rng"
      ];
      #initrd.kernelModules = [
      #  "watchdog"
      #  "isgx"
      #];
    };
  };
}
