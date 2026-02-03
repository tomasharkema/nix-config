{
  lib,
  pkgs,
  inputs,
  config,
  ...
}: let
  boot-into-bios = pkgs.writeShellScriptBin "boot-into-bios" ''
    sudo ${pkgs.ipmitool}/bin/ipmitool chassis bootparam set bootflag force_bios
  '';
  workerPort = "9988";
in {
  imports = with inputs; [
    nvidia-vgpu-nixos.nixosModules.host
  ];

  config = {
    age = {
      rekey = {
        hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOyaxzAidYV34BVF4QEEE+BDRicP1yJMhOXzOrTt3jfo root@nixos";
      };
      secrets = {
        tsnsrv = {
          rekeyFile = ../../../modules/nixos/secrets/tsnsrv.age;
        };
      };
    };

    facter.reportPath = ./facter.json;

    disks.btrfs = {
      enable = true;
      main = "/dev/disk/by-id/ata-Samsung_SSD_850_EVO_500GB_S21JNXBGC17548K";
      second = "/dev/disk/by-id/ata-KINGSTON_SA400S37480G_50026B778512DF0";

      # media = "/dev/disk/by-id/ata-TOSHIBA_MK3263GSXN_5066P0YHT";

      # boot = "/dev/disk/by-id/usb-Kingston_DataTraveler_3.0_1C1B0D6AE9B0E410390F2CA6-0:0";

      # btrbk.enable = true;
    };

    traits = {
      server = {
        enable = true;
        headless.enable = true;
        ipmi.enable = true;
      };

      hardware = {
        tpm.enable = true;
        secure-boot.enable = true;
        # remote-unlock.enable = false;
        network.xgbe.enable = true;
        nvidia = {
          enable = true;
          beta = false;
          open = false;
          grid = {
            enable = false;
          };
        };
      };
    };

    apps = {
      atop = {
        enable = true;
        httpd = false;
      };
      # "bmc-watchdog".enable = true;
      docker.enable = true;
      usbguard.enable = false;
    };

    services = {
      hypervisor = {
        enable = true;
        # bridgeInterfaces = [ "eno1" ];
      };

      # netconsoled.enable = true;

      avahi.allowInterfaces = ["br0"];
      vscode-server.enable = true;
      rpcbind.enable = true;
      lldpd.enable = true;
      remote-builders.server.enable = true;
      # netbootxyz.enable = true;
      # tcsd.enable = true;
      kmscon.enable = lib.mkForce false;

      prometheus.exporters = {
        ipmi = {
          enable = true;
        };
      };
    };
    programs.usbtop.enable = true;

    powerManagement.powertop.enable = true;

    networking = {
      # hosts = {
      #   "192.168.0.100" = ["nix-cache.harke.ma"];
      # };
      hostName = "blue-fire";

      usePredictableInterfaceNames = true;
      useDHCP = false;
      networkmanager.enable = true;

      firewall = {
        allowPing = true;

        enable = false;
      };

      nameservers = ["192.168.0.1"];

      bridges.br0 = {
        interfaces = ["enp6s0"];
      };
      vlans = {
        "vlan69" = {
          id = 69;
          interface = "enp6s0";
        };
        "vlan66" = {
          id = 66;
          interface = "enp6s0";
        };
      };

      defaultGateway = {
        address = "192.168.0.1";
        interface = "br0";
      };

      interfaces = {
        "eno1" = {
          useDHCP = false;
          wakeOnLan.enable = true;
          mtu = 9000;
        };

        "eno2" = {
          useDHCP = false;
          wakeOnLan.enable = true;
          mtu = 9000;
        };

        "eno3" = {
          useDHCP = false;
          wakeOnLan.enable = true;
          mtu = 9000;
        };

        "eno4" = {
          useDHCP = false;
          wakeOnLan.enable = true;
          mtu = 9000;
        };

        "enp6s0" = {
          useDHCP = false;
          wakeOnLan.enable = true;
          mtu = 9000;
        };
        "br0" = {
          useDHCP = false;
          mtu = 9000;
          ipv4.addresses = [
            {
              address = "192.168.0.101";
              prefixLength = 24;
            }
          ];
        };
        "vlan69" = {
          useDHCP = true;
          wakeOnLan.enable = true;
          mtu = 9000;
        };
        "vlan66" = {
          useDHCP = true;
          wakeOnLan.enable = true;
          mtu = 9000;
        };
        #"bond0" = {
        #  mtu = 9000;
        #};
      };
    };

    # environment.systemPackages = with pkgs; [
    #   virt-manager
    #  ipmitool
    #  boot-into-bios
    #  openipmi
    #  freeipmi
    #  ipmicfg
    #  ipmiutil
    #  tremotesf
    #  icingaweb2
    # ];

    virtualisation.kvmgt = {
      enable = true;
      device = "0000:01:00.0";
      vgpus = {
        # USE Q TYPE
        # nvidia-47
        #  Available instances: 12
        #  Device API: vfio-pci
        #  Name: GRID P40-2Q
        #  Description: num_heads=4, frl_config=60, framebuffer=2048M, max_resolution=7680x4320, max_instance=12
        "nvidia-47" = {
          uuid = [
            "e1ab260f-44a2-4e07-9889-68a1caafb399"
            "f6a3e668-9f62-11ef-b055-fbc0e7d80867"
          ];
        };
      };
    };
    hardware = {
      cpu.intel.updateMicrocode = true;

      enableAllFirmware = true;
      enableRedistributableFirmware = true;

      nvidia = {
        # forceFullCompositionPipeline = true;
        nvidiaSettings = lib.mkForce false;
        nvidiaPersistenced = lib.mkForce false;
      };
    };

    boot = {
      tmp = {
        useTmpfs = true;
      };

      kernelPackages = lib.mkForce pkgs.linuxPackages_6_12;

      supportedFilesystems = [
        "xfs"
        "ntfs"
        # "apfs"
        "ext4"
        "btrfs"
      ];

      kernelParams = [
        "console=tty1"
        "console=ttyS2,115200n8r"
        # "earlyprintk=ttyS2"
        # "rootdelay=300"
        "panic=1"
        "boot.panic_on_fail"
        # "vfio-pci.ids=10de:1c82"
        # "pcie_acs_override=downstream,multifunction"
        # "vfio_iommu_type1.allow_unsafe_interrupts=1"
        # "kvm.ignore_msrs=1"
        # "pci=nomsi"
        "intel_iommu=on"
        "ipmi_watchdog.preop=preop_give_data"
        "ipmi_watchdog.preaction=pre_int"
        "ipmi_watchdog.timeout=180"
      ];

      modprobeConfig.enable = true;

      # binfmt.emulatedSystems = ["aarch64-linux"];

      recovery = {
        sign = true;
        install = true;
        netboot.enable = true;
      };

      # loader = {
      #   systemd-boot.enable = false;

      #   efi = {
      #     canTouchEfiVariables = true;
      #     efiSysMountPoint = "/boot";
      #   };
      #   grub = {
      #     enable = true;
      #     efiSupport = true;
      #     #efiInstallAsRemovable = true;
      #     device = "nodev";
      #     # netbootxyz.enable = true;
      #     memtest86.enable = true;
      #     extraFiles = {
      #       "efi/netbootxyz/netboot.xyz.efi" = "${pkgs.netbootxyz-efi}";
      #     };
      #     extraEntries = ''
      #       menuentry "netboot.xyz" {
      #         search --no-floppy --file --set=root /EFI/netbootxyz/netboot.xyz.efi
      #         chainloader /EFI/netbootxyz/netboot.xyz.efi
      #       }
      #     '';
      #     extraConfig = ''
      #       serial --unit=2 --speed=115200 --word=8 --parity=no --stop=1
      #       terminal_input --append serial
      #       terminal_output --append serial
      #     '';

      #     # ipxe = {
      #     #   netboot-xyz = ''
      #     #     #!ipxe
      #     #     dhcp
      #     #     chain --autofree https://boot.netboot.xyz
      #     #   '';
      #     # };
      #   };
      # };

      blacklistedKernelModules = ["iTCO_wdt"];

      kernelModules = [
        "pci-me"
        "nct6775"
        "coretemp"
        "kvm-intel"
        "uinput"
        "fuse"
        "ipmi_ssif"
        "acpi_ipmi"
        "ipmi_si"
        "ipmi_devintf"
        "ipmi_msghandler"
        "ipmi_watchdog"
        "bt_bmc"
        "vfio"
        "vfio_pci"
        "vfio_virqfd"
        "vfio_iommu_type1"
        "ipmi_poweroff"
      ];
    };
  };
}
