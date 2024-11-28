{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.services.hypervisor;
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

    systemd.packages = [pkgs.custom.libvirt-dbus];

    environment.etc = {
      "libvirt/virtio-win".source = pkgs.virtio-win;
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

    boot = {
      kernelParams = [
        "kvm_intel.nested=1"
      ];
      kernelModules = [
        "mdev"
        "kvmgt"
      ];
    };

    # programs.ccache = {
    #   enable = true;
    # };

    hardware.ksm.enable = true;

    virtualisation = {
      kvmgt.enable = true;
      # tpm.enable = true;

      # libvirt = {
      #   enable = true;
      #   swtpm.enable = true;
      # };

      libvirtd = {
        enable = true;

        qemu = {
          package = pkgs.qemu_kvm;
          # runAsRoot = true;
          verbatimConfig = ''
            #   # Adapted from /var/lib/libvirt/qemu.conf
            #   # Note that AAVMF and OVMF are for Aarch64 and x86 respectively
              nvram = [ "/run/libvirt/nix-ovmf/AAVMF_CODE.fd:/run/libvirt/nix-ovmf/AAVMF_VARS.fd", "/run/libvirt/nix-ovmf/OVMF_CODE.fd:/run/libvirt/nix-ovmf/OVMF_VARS.fd" ]
          '';
          swtpm.enable = true;

          vhostUserPackages = [pkgs.virtiofsd];

          ovmf = {
            enable = true;
            packages = [
              ((pkgs.OVMFFull)
                .fd)
              ((pkgs.pkgsCross.aarch64-multiplatform.OVMF.override {
                  secureBoot = true;
                  tpmSupport = true;
                })
                .fd)
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

    users.users = {
      "${config.user.name}".extraGroups = ["libvirtd" "qemu-libvirtd" "vboxusers"];
      "root".extraGroups = ["libvirtd" "qemu-libvirtd" "vboxusers"];
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
