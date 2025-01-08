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
    ./hardware-configuration.nix

    # nixos-hardware.nixosModules.common-cpu-intel
    # nixos-hardware.nixosModules.common-pc-ssd
    nvidia-vgpu-nixos.nixosModules.host
  ];

  config = {
    age = {
      rekey = {
        hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKMfjVCxpx87jpHR6CAUoZsEvwZOSTKyUmYDl3vXIUeu root@silver-star";
      };
    };

    facter.reportPath = ./facter.json;

    disks.btrfs = {
      enable = true;
      main = "/dev/nvme0n1";
      second = "/dev/nvme1n1";
      boot = "/dev/sda";
      # btrbk.enable = true;
    };

    traits = {
      server = {
        enable = true;
        headless.enable = true;
      };

      builder.enable = true;

      hardware = {
        # tpm.enable = true;
        secure-boot.enable = true;
      };
    };

    apps = {
      netdata.server.enable = true;
      # attic-server.enable = true;
      ntopng.enable = true;
      mailrise.enable = true;
      atop = {
        enable = true;
        httpd = true;
      };
      # "bmc-watchdog".enable = true;
      podman.enable = true;
      zabbix.server.enable = true;
      atticd.enable = true;
    };
    programs.mosh.enable = true;
    services = {
      hypervisor = {
        enable = true;
        # bridgeInterfaces = [ "eno1" ];
      };
      # mosh.enable = true;
      # xserver.videoDrivers = ["nvidia"];

      "nix-private-cache".enable = true;

      tcsd.enable = true;
      throttled.enable = lib.mkForce false;
      usbguard.enable = false;
      watchdogd = {
        enable = true;
      };

      das_watchdog.enable = lib.mkForce false;

      remote-builders.server.enable = true;

      beesd.filesystems = {
        root = {
          spec = "UUID=948d8479-177a-4204-a6a8-5d2013f3dc88";
          hashTableSizeMB = 2048;
          verbosity = "crit";
          extraOptions = [
            "--loadavg-target"
            "2.0"
          ];
        };
      };
      # icingaweb2 = {
      #   enable = true;
      #   virtualHost = "mon.blue-fire.harkema.intra";
      #   modules.setup.enable = true;
      #   authentications = {
      #     icingaweb = {
      #       backend = "db";
      #       resource = "icingaweb_db";
      #     };
      #   };
      # };

      # ha.initialMaster = true;
      # command-center = {
      #   enableBot = true;
      # };

      # tcsd.enable = true;
      kmscon.enable = lib.mkForce false;

      prometheus.exporters = {
        ipmi = {
          enable = true;
        };
      };
      # nfs = {
      #   server = {
      #     enable = true;
      #     exports = ''
      #       /export/media        *(rw,fsid=0,no_subtree_check)
      #     '';
      #   };
      # };
    };

    systemd = {
      watchdog = {
        device = "/dev/watchdog";
        runtimeTime = "5m";
        kexecTime = "5m";
        rebootTime = "5m";
      };

      services."docker-compose@atuin".wantedBy = ["multi-user.target"];
    };

    # services = {
    # podman.enable = true;
    # freeipa.replica.enable = true;
    # };

    networking = {
      hostName = "silver-star";

      firewall = {
        allowPing = true;
      };

      bridges.br0 = {
        interfaces = ["enp5s0"];
      };

      interfaces = {
        "enp5s0" = {
          # useDHCP = lib.mkDefault true;
          wakeOnLan.enable = true;
          mtu = 9000;
        };
        "eno1" = {
          useDHCP = lib.mkDefault false;
          wakeOnLan.enable = true;
          mtu = 9000;
        };
        "eno2" = {
          wakeOnLan.enable = true;
          mtu = 9000;
        };
        "eno3" = {
          useDHCP = lib.mkDefault false;
          wakeOnLan.enable = true;
          mtu = 9000;
        };
        "eno4" = {
          useDHCP = lib.mkDefault false;
          wakeOnLan.enable = true;
          mtu = 9000;
        };
        "br0" = {
          useDHCP = lib.mkDefault true;
          mtu = 9000;
        };
      };

      # useDHCP = false;
      networkmanager.enable = true;
    };

    environment.systemPackages = with pkgs; [
      # ipmicfg
      # ipmiview
      # ipmiutil
      # vagrant
      simpleTpmPk11
      libsmbios
      virt-manager
      ipmitool
      boot-into-bios
      openipmi
      freeipmi
      ipmicfg
      ipmiutil
      tremotesf
      # icingaweb2
    ];

    virtualisation.kvmgt = {
      enable = true;
      device = "0000:42:00.0";
      vgpus = {
        "nvidia-36" = {
          uuid = [
            "e1ab260f-44a2-4e07-9889-68a1caafb399"
            "f6a3e668-9f62-11ef-b055-fbc0e7d80867"
          ];
        };
      };
    };

    # fileSystems."/etc" = {
    #   device = "none";
    #   fsType = "tmpfs";
    #   options = ["defaults" "size=25%" "mode=755"];
    # };

    hardware = {
      cpu.intel.updateMicrocode = true;

      enableAllFirmware = true;
      enableRedistributableFirmware = true;

      # nvidia-container-toolkit.enable = true;

      nvidia = {
        modesetting.enable = true;
        #     # forceFullCompositionPipeline = true;
        nvidiaSettings = lib.mkForce false;

        package = config.boot.kernelPackages.nvidiaPackages.vgpu_16_5;

        vgpu.patcher = {
          enable = true;
          options.doNotForceGPLLicense = false;
          copyVGPUProfiles = {
            "1c82:0000" = "13BD:1160";
          };
          enablePatcherCmd = true;
        };
      };
    };

    virtualisation.oci-containers.containers = {
      openmanage = {
        image = "docker.io/teumaauss/srvadmin";

        imageFile = pkgs.dockerTools.pullImage {
          imageName = "docker.io/teumaauss/srvadmin";
          imageDigest = "sha256:287ed0729a3250f114b0369b3a462ba50fc59f8531ef56518804ea4c60e91b52";
          sha256 = "0in9idw5mclh304968j0fsf5qcqsqp60g7x04ga0pn8bcynrjjr7";
          finalImageName = "docker.io/teumaauss/srvadmin";
          finalImageTag = "latest";
        };

        volumes = let
          kernelVideo = config.boot.kernelPackages.kernel.version;
        in [
          "/run/current-system/sw/lib/modules/${kernelVideo}:/lib/modules/${kernelVideo}"
          "/usr/libexec/dell_dup:/usr/libexec/dell_dup:Z"
        ];

        extraOptions = [
          "--privileged"
          "--net=host"
          "--device=/dev/mem"
          "--systemd=always"
        ];
        autoStart = true;
      };

      fastapi-dls = {
        image = "collinwebdesigns/fastapi-dls";
        imageFile = pkgs.dockerTools.pullImage {
          imageName = "collinwebdesigns/fastapi-dls";
          imageDigest = "sha256:0039c37c10144e83588c90980fb0fb6225a9bf5c6301ae6823db6fad79d21acb";
          sha256 = "0yr2dn0dzslp7dc0i6v6kfqbasdkrg36vywr15kizhy0cfgkfrpr";
          finalImageName = "collinwebdesigns/fastapi-dls";
          finalImageTag = "latest";
        };
        volumes = [
          "/var/lib/fastapi-dls/cert:/app/cert:rw"
          "dls-db:/app/database"
        ];
        # Set environment variables
        environment = {
          TZ = "Europa/Amsterdam";
          DLS_URL = config.networking.hostName;
          DLS_PORT = "443";
          LEASE_EXPIRE_DAYS = "90";
          DATABASE = "sqlite:////app/database/db.sqlite";
          DEBUG = "true";
        };
        extraOptions = [
        ];
        # Publish the container's port to the host
        ports = ["7070:443"];
        # Do not automatically start the container, it will be managed
        autoStart = true;
      };
    };
    # services.udev.extraRules = ''
    #   SUBSYSTEM=="vfio", OWNER="root", GROUP="kvm"
    # '';

    boot = {
      tmp = {
        useTmpfs = true;
      };
      binfmt.emulatedSystems = ["aarch64-linux"];
      kernelPackages = pkgs.linuxPackages_6_6;
      kernelParams = [
        "intel_iommu=on"
        "iommu=pt"
        # "console=tty1"
        # "console=ttyS2,115200n8"
        "mitigations=off"
        #"vfio-pci.ids=10de:1380,10de:0fbc"
        # "pcie_acs_override=downstream,multifunction"
        # "vfio_iommu_type1.allow_unsafe_interrupts=1"
        # "kvm.ignore_msrs=1"
        "iomem=relaxed"
        # "pci=nomsi"
      ];
      blacklistedKernelModules = ["nouveau"];

      recovery = {
        enable = true;
        install = true;
        sign = true;
        netboot.enable = true;
      };

      loader = {
        systemd-boot = {
          # enable = true;
          configurationLimit = 10;
        };
        efi.canTouchEfiVariables = true;
      };

      initrd = {
        availableKernelModules = [
          "xhci_pci"
          "ahci"
          "usbhid"
          "usb_storage"
          "dell_rbu"
          "dcdbas"
          # "sd_mod"
        ];
        kernelModules = [
          "dcdbas"
          "dell_rbu"
          # "pci-me"
          "kvm-intel"

          "uinput"
          #          "tpm_rng"
          "ipmi_ssif"
          # "acpi_ipmi"
          "ipmi_si"
          "ipmi_devintf"
          "ipmi_msghandler"
          "vfio_pci"
          "vfio"
          "vfio_iommu_type1"
          # "vfio_virqfd"

          # "nvidia"
          # "nvidia_modeset"
          # "nvidia_uvm"
          # "nvidia_drm"
        ];
      };
      kernelModules = [
        "pci-me"
        "coretemp"
        "kvm-intel"
        "uinput"
        "fuse"
        #       "tpm_rng"
        "ipmi_ssif"
        # "acpi_ipmi"
        "ipmi_si"
        "ipmi_devintf"
        "ipmi_msghandler"
        "ipmi_watchdog"

        "vfio_pci"
        "vfio"
        "vfio_iommu_type1"
        # "vfio_virqfd"

        # "nvidia"
        # "nvidia_modeset"
        # "nvidia_uvm"
        # "nvidia_drm"
      ];

      systemd.services."serial-getty@ttyS2" = {
        #   overrideStrategy = "asDropin";
        #   serviceConfig = let
        #     tmux = pkgs.writeShellScript "tmux.sh" ''
        #       ${pkgs.tmux}/bin/tmux kill-session -t start 2> /dev/null
        #       ${pkgs.tmux}/bin/tmux new-session -s start
        #     '';
        #   in {
        #     TTYVTDisallocate = "no";
        #     #ExecStart = ["" "-${tmux}"];
        #     #StandardInput = "tty";
        #     #StandardOutput = "tty";
        #   };
        wantedBy = ["multi-user.target"];
        #   #environment.TERM = "vt102";
      };
    };
  };
}
