{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.headless.hypervisor;
in {
  options.headless.hypervisor = {
    enable = mkEnableOption "hypervisor";
  };

  config = mkIf cfg.enable {
    system.nixos.tags = ["hypervisor"];

    # specialisation."VFIO".configuration = {
    #   system.nixos.tags = ["with-vfio"];
    #   vfio.enable = true;
    # };

    environment.systemPackages = with pkgs; [
      virt-manager
      gnome.gnome-boxes
      # kvm
    ];

    programs.virt-manager.enable = true;

    virtualisation.libvirtd = {
      enable = true;
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
            pkgs.pkgsCross.aarch64-multiplatform.OVMF.fd #
          ];
        };
      };
    };

    users.users.${config.user.name}.extraGroups = ["libvirtd"];

    virtualisation.libvirtd.allowedBridges = ["br0"];

    networking.interfaces."br0".useDHCP = true;

    networking.bridges = {
      "br0" = {
        interfaces = ["wlp59s0"];
      };
    };

    # dconf.settings = {
    #   "org/virt-manager/virt-manager/connections" = {
    #     autoconnect = ["qemu:///system"];
    #     uris = ["qemu:///system"];
    #   };
    # };

    networking.firewall.trustedInterfaces = ["virbr0"];
  };
}
