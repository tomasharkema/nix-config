{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.services.hypervisor;
  # isosStorage = pkgs.writeText "isos.xml" ''
  #   <pool type="netfs">
  #     <name>virtimages</name>
  #     <source>
  #       <host name="192.168.1.102"/>
  #       <dir path="/volume1/isos"/>
  #       <format type='nfs'/>
  #     </source>
  #     <target>
  #       <path>/var/lib/libvirt/images/isos-2</path>
  #     </target>
  #   </pool>
  # '';
in {
  options.services.hypervisor = {
    enable = lib.mkEnableOption "hypervisor";
    iommu.enable = lib.mkEnableOption "hypervisor";
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

    environment.systemPackages = with pkgs; [
      kvmtool
      libvirt
      qemu
      pkgs.custom.libvirt-dbus
      # nemu
      # qtemu
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
        qemu

        pkgs.custom.libvirt-dbus
      ];

      # prometheus.exporters = {
      #   libvirt.enable = true;
      # };
      rpcbind.enable = true;
    };

    # users = {
    #   users = {
    #     qemu-libvirtd.group = "qemu-libvirtd";
    #   };
    #   groups.qemu-libvirtd = {};
    # };

    users = {
      groups = {
        "incus-admin".members = [
          "${config.user.name}"
        ];

        "qemu-libvirtd".members = [
          "${config.user.name}"
        ];
      };

      users = {
        root.extraGroups = [
          "kvm"
          "libvirtd"
          "tty"

          "libvirt"
          "qemu-libvirtd"
        ];
        "${config.user.name}".extraGroups = [
          "kvm"
          "libvirtd"
          "libvirt"
          "tty"
          "qemu-libvirtd"
        ];
      };
    };

    systemd = {
      # tmpfiles.settings."9-isos" = {
      #   "/var/lib/libvirt/storage/isos.xml" = {
      #     "L+" = {
      #       argument = "${isosStorage}";
      #       mode = "600";
      #     };
      #   };
      # };

      packages = [pkgs.custom.libvirt-dbus];
    };

    environment.etc = {
      "libvirt/virtio-win".source = pkgs.virtio-win;
      "libvirt/virtio-win.iso".source = pkgs.virtio-win.src;

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
    };

    services.saslauthd = {
      enable = true;
      # config = ''
      #   mech_list: gssapi
      #   keytab: ${libvirtKeytab}
      # '';
    };
    services.udev.extraRules = ''
      SUBSYSTEM=="vfio", OWNER="root", GROUP="kvm"
    '';

    boot = {
      kernelParams = lib.mkIf cfg.iommu.enable [
        "kvm_intel.nested=1"
        "intel_iommu=on"
        # "intel_iommu=igfx_off"
        "hugepagesz=2M"
        "hugepages=2048"
      ];
      # blacklistedKernelModules = [
      #   "nvidia"
      #   "nouveau"
      # ];
      kernelModules =
        if cfg.iommu.enable
        then
          #lib.mkBefore
          [
            "kvm-intel"
            "mdev"
            "kvmgt"
            "vfio_pci"
            "vfio"
            "vfio_iommu_type1"
          ]
        else ["kvm-intel"];
      initrd.kernelModules = lib.mkIf cfg.iommu.enable (
        #lib.mkBefore
        [
          "kvm-intel"
          "vfio_pci"
          "vfio"
          "vfio_iommu_type1"
        ]
      );
    };

    programs = {
      mdevctl.enable = true;
      ccache.enable = true;
    };

    hardware.ksm.enable = true;

    virtualisation = {
      incus = {
        enable = true;
        ui.enable = true;
      };

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
          # verbatimConfig = ''
          #   cgroup_device_acl = [
          #     "/dev/null",
          #     "/dev/full",
          #     "/dev/zero",
          #     "/dev/random",
          #     "/dev/urandom",
          #     "/dev/ptmx",
          #     "/dev/kvm",
          #     "/dev/kqemu",
          #     "/dev/rtc",
          #     "/dev/hpet",
          #     "/dev/pts"
          #   ]
          # '';

          swtpm.enable = true;

          vhostUserPackages = [pkgs.virtiofsd];
        };
      };

      # libvirtd = {
      #   enable = true;
      #   # allowedBridges = ["virbr1"];

      #   # extraConfig = ''
      #   #   listen_tls = 0
      #   #   listen_tcp = 1
      #   #   auth_tcp = "sasl"
      #   #   sasl_allowed_username_list = ["\*@HARKEMA.IO" ]
      #   # '';

      #   allowedBridges = ["virbr0" "br0"];

      #   qemu = {
      #     package = pkgs.qemu_kvm;
      #     runAsRoot = true;
      #     swtpm.enable = true;

      #   };
      # };
    };

    networking = {
      # nftables.enable = true;

      #   interfaces."br0".useDHCP = true;

      # firewall.trustedInterfaces = ["br0" "virbr0"];

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
