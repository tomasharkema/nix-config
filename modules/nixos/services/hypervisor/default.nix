{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.headless.hypervisor;

  libvirtKeytab = "/var/lib/libvirt/krb5.tab";
  qemuKeytab = "/etc/qemu/krb5.tab";
in {
  options.headless.hypervisor = {
    enable = mkEnableOption "hypervisor";

    bridgeInterfaces = mkOpt (types.listOf types.str) [] "bridgeInterfaces";
  };

  config = mkIf cfg.enable {
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
      virt-manager
      kvmtool
      libvirt
      qemu_kvm
      pkgs.custom.libvirt-dbus
      # nemu
      qtemu
      dosbox-x
      qemu-utils
      virtiofsd
    ];

    services.udev.packages = with pkgs; [virtiofsd];

    services.dbus.packages = with pkgs; [
      virtiofsd
      virt-manager
      kvmtool
      libvirt
      qemu_kvm

      pkgs.custom.libvirt-dbus
    ];

    programs.virt-manager.enable = true;

    environment.etc = {
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

    # services.saslauthd = {
    # enable = true;
    # config = ''
    #   mech_list: gssapi
    #   keytab: ${libvirtKeytab}
    # '';
    # };

    boot.extraModprobeConfig = "options kvm_intel nested=1";

    virtualisation = {
      kvmgt.enable = true;

      libvirt = {
        enable = true;
        swtpm.enable = true;
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
      "${config.user.name}".extraGroups = ["libvirtd" "qemu-libvirtd"];
      "root".extraGroups = ["libvirtd" "qemu-libvirtd"];
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
