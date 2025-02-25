{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.services.hypervisor;

  isosStorage = pkgs.writeText "isos.xml" ''
    <pool type="netfs">
      <name>virtimages</name>
      <source>
        <host name="192.168.1.102"/>
        <dir path="/volume1/isos"/>
        <format type='nfs'/>
      </source>
      <target>
        <path>/var/lib/libvirt/images/isos-2</path>
      </target>
    </pool>
  '';
in {
  options.services.hypervisor = {
    enable = lib.mkEnableOption "hypervisor";

    webservices.enable = lib.mkEnableOption "webservices";

    bridgeInterfaces = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [];
      description = "bridgeInterfaces";
    };
  };

  config = lib.mkIf cfg.enable {
    system = {
      nixos.tags = ["hypervisor"];

      # activationScripts = {
      #   libvirtKeytab = ''
      #     if [ ! -f "${libvirtKeytab}" ]; then
      #       ${pkgs.freeipa}/bin/ipa-getkeytab -s ipa.harkema.intra -p libvirt/${config.networking.hostName}.harkema.intra -k ${libvirtKeytab} --principal=domainjoin --password "$(cat ${config.age.secrets.domainjoin.path})"
      #     fi
      #   '';
      #   qemuKeytab = ''
      #     if [ ! -f "${qemuKeytab}" ]; then
      #       ${pkgs.freeipa}/bin/ipa-getkeytab -s ipa.harkema.intra -p vnc/${config.networking.hostName}.harkema.intra -k ${qemuKeytab} --principal=domainjoin --password "$(cat ${config.age.secrets.domainjoin.path})"
      #     fi
      #   '';
      # };
    };

    # specialisation."VFIO".configuration = {
    #   system.nixos.tags = ["with-vfio"];
    #   vfio.enable = true;
    # };

    # programs.looking-glass = {
    #   enable = true;

    #   shm = {
    #     user = "tomas";
    #   };
    # };

    programs.mdevctl.enable = true;

    environment.systemPackages = with pkgs; [
      kvmtool
      libvirt
      qemu_kvm
      pkgs.custom.libvirt-dbus
      # nemu
      qtemu
      virt-top
      _86Box-with-roms
      # remotebox
      qemu-utils
      virtiofsd
    ];

    services = {
      udev.packages = with pkgs; [virtiofsd];

      dbus.packages = with pkgs; [
        virtiofsd
        virt-manager
        kvmtool
        libvirt
        qemu_kvm

        pkgs.custom.libvirt-dbus
      ];
    };

    # users = {
    #   users = {
    #     qemu-libvirtd.group = "qemu-libvirtd";
    #     "${config.user.name}".extraGroups = ["libvirtd" "qemu-libvirtd" "vboxusers"];
    #     "root".extraGroups = ["libvirtd" "qemu-libvirtd" "vboxusers"];
    #   };
    #   groups.qemu-libvirtd = {};
    # };

    users.users = {
      root.extraGroups = [
        "kvm"
        "libvirtd"
        "tty"

        "libvirt"
        "qemu-libvirtd"
      ];
      tomas.extraGroups = [
        "kvm"
        "libvirtd"
        "libvirt"
        "tty"
        "qemu-libvirtd"
      ];
    };

    services.rpcbind.enable = true;

    systemd = {
      tmpfiles.settings."9-isos" = {
        "/var/lib/libvirt/storage/isos.xml" = {
          "L+" = {
            argument = "${isosStorage}";
            mode = "600";
          };
        };
      };

      mounts = [
        {
          type = "nfs";
          mountConfig = {
            Options = "noatime";
          };
          what = "192.168.1.102:/volume1/isos";
          where = "/var/lib/libvirt/images/isos";
        }
      ];

      automounts = [
        {
          wantedBy = ["multi-user.target"];
          automountConfig = {
            TimeoutIdleSec = "600";
          };
          where = "/var/lib/libvirt/images/isos";
        }
      ];

      packages = [pkgs.custom.libvirt-dbus];
    };

    environment.etc = {
      "libvirt/virtio-win".source = pkgs.virtio-win;
      "libvirt/virtio-win.iso".source = pkgs.virtio-win.src;

      "ovmf/x86.fd".source = config.system.build.ovmf-x86;
      "ovmf/aarch.fd".source = config.system.build.ovmf-aarch;

      # "sasl2/libvirt.conf" = {
      #   text = ''
      #     mech_list: gssapi
      #     keytab: ${libvirtKeytab}
      #   '';
      # };
      # "libvirt/qemu.conf" = {
      #   text = ''
      #     vnc_listen = "0.0.0.0"
      #     vnc_tls = 0
      #     vnc_sasl = 1
      #   '';
      # };
      # "sasl2/qemu-kvm.conf" = {
      #   text = ''
      #     mech_list: gssapi
      #     keytab: ${qemuKeytab}
      #   '';
      # };
      # "libvirt/qemu.conf" = {
      #   text = ''
      #     # Adapted from /var/lib/libvirt/qemu.conf
      #     # Note that AAVMF and OVMF are for Aarch64 and x86 respectively
      #     nvram = [ "/run/libvirt/nix-ovmf/AAVMF_CODE.fd:/run/libvirt/nix-ovmf/AAVMF_VARS.fd", "/run/libvirt/nix-ovmf/OVMF_CODE.fd:/run/libvirt/nix-ovmf/OVMF_VARS.fd" ]
      #   '';
      # };
    };

    # services.saslauthd = {
    # enable = true;
    # config = ''
    #   mech_list: gssapi
    #   keytab: ${libvirtKeytab}
    # '';
    # };
    # services.udev.extraRules = ''
    #   SUBSYSTEM=="vfio", OWNER="root", GROUP="kvm"
    # '';
    boot = {
      kernelParams = [
        "kvm_intel.nested=1"
        "intel_iommu=on"
        "intel_iommu=igfx_off"
        "default_hugepagesz=1G"
        "hugepagesz=1G"
        "hugepages=1"
      ];
      # blacklistedKernelModules = [
      #   "nvidia"
      #   "nouveau"
      # ];
      kernelModules = lib.mkBefore [
        "kvm-intel"
        "mdev"
        "kvmgt"
        "vfio_pci"
        "vfio"
        "vfio_iommu_type1"
      ];
      # initrd.kernelModules = lib.mkBefore [
      #   "kvm-intel"
      #   "vfio_pci"
      #   "vfio"
      #   "vfio_iommu_type1"
      # ];
    };

    # programs.ccache = {
    #   enable = true;
    # };

    hardware.ksm.enable = true;

    system.build = {
      ovmf-x86 =
        (pkgs.OVMFFull)
        .fd;
      ovmf-aarch =
        (pkgs.pkgsCross.aarch64-multiplatform.OVMF.override {
          secureBoot = true;
          tpmSupport = true;
        })
        .fd;
    };

    virtualisation = {
      kvmgt.enable = true;
      # tpm.enable = true;

      # vfio = {
      #   enable = true;
      #   IOMMUType = "intel";
      #   blacklistNvidia = true;
      #   ignoreMSRs = true;
      # };

      libvirtd = {
        enable = true;

        nss = {
          enable = true;
          enableGuest = true;
        };

        qemu = {
          package = pkgs.qemu_kvm;
          runAsRoot = true;
          verbatimConfig = ''
            cgroup_device_acl = [
              "/dev/null",
              "/dev/full",
              "/dev/zero",
              "/dev/random",
              "/dev/urandom",
              "/dev/ptmx",
              "/dev/kvm",
              "/dev/kqemu",
              "/dev/rtc",
              "/dev/hpet",
              "/dev/pts"
            ]
          '';
          #   nvram = [ "/run/libvirt/nix-ovmf/AAVMF_CODE.fd:/run/libvirt/nix-ovmf/AAVMF_VARS.fd", "/run/libvirt/nix-ovmf/OVMF_CODE.fd:/run/libvirt/nix-ovmf/OVMF_VARS.fd" ]

          swtpm.enable = true;

          vhostUserPackages = [pkgs.virtiofsd];

          ovmf = {
            enable = true;
            packages = [
              config.system.build.ovmf-x86
              config.system.build.ovmf-aarch
            ];
          };
        };
      };

      # libvirtd = {
      #   enable = true;
      #   # allowedBridges = ["virbr1"];

      #   # extraConfig = ''
      #   #   listen_tls = 0
      #   #   listen_tcp = 1
      #   #   auth_tcp = "sasl"
      #   #   sasl_allowed_username_list = ["\*@HARKEMA.INTRA" ]
      #   # '';

      #   allowedBridges = ["virbr0" "br0"];

      #   qemu = {
      #     package = pkgs.qemu_kvm;
      #     runAsRoot = true;
      #     swtpm.enable = true;

      #     ovmf = {
      #       enable = true;
      #       packages = [
      #         # (pkgs.OVMF.override {
      #         #   secureBoot = true;
      #         #   tpmSupport = true;
      #         # })
      #         pkgs.OVMFFull.fd
      #         # pkgs.pkgsCross.aarch64-multiplatform.OVMF.fd
      #       ];
      #     };
      #   };
      # };
    };

    networking = {
      #   interfaces."br0".useDHCP = true;

      firewall.trustedInterfaces = ["br0" "virbr0"];

      #   bridges = {
      #     "br0" = {
      #       interfaces = ["wlp59s0"];
      #     };
      #   };
    };

    # dconf.settings = {
    #   "org/virt-manager/virt-manager/connections" = {
    #     autoconnect = ["qemu:///system"];
    #     uris = ["qemu:///system"];
    #   };
    # };
  };
}
