{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.headless.hypervisor;
in {
  options.headless.hypervisor = {
    enable = mkEnableOption "hypervisor";

    bridgeInterfaces = mkOpt (types.listOf types.str) [] "bridgeInterfaces";
  };

  config = mkIf cfg.enable {
    system.nixos.tags = ["hypervisor"];

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
      # kvm
      # gnome
    ];
    services.dbus.packages = with pkgs; [
      libvirt
      virt-manager
    ];

    networking = {
      interfaces.br0.useDHCP = true;
      bridges = {
        "br0" = {
          interfaces = cfg.bridgeInterfaces;
        };
      };
    };

    programs.virt-manager.enable = true;

    virtualisation.libvirtd = {
      enable = true;
      # allowedBridges = ["virbr1"];
      allowedBridges = ["virbr0" "br0"];
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
        ovmf = {
          enable = true;
          packages = [
            (pkgs.OVMF.override {
              secureBoot = true;
              tpmSupport = true;
            })
            .fd
            # pkgs.pkgsCross.aarch64-multiplatform.OVMF.fd
          ];
        };
      };
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
