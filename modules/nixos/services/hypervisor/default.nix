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
      kvmtool
      libvirt
      gnome.gnome-boxes
      qemu_kvm
      # kvm
    ];
    services.dbus.packages = with pkgs; [
      libvirt
      virt-manager
    ];

    programs.virt-manager.enable = true;

    virtualisation.libvirtd = {
      enable = true;
      # allowedBridges = ["virbr0"];
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

    users.users.${config.user.name}.extraGroups = ["libvirtd" "qemu-libvirtd"];
    users.users."root".extraGroups = ["libvirtd" "qemu-libvirtd"];

    networking = {
      #   interfaces."br0".useDHCP = true;

      #   bridges = {
      #     "br0" = {
      #       interfaces = ["wlp59s0"];
      #     };
      #   };
      #   firewall.trustedInterfaces = ["br0"];
      firewall.trustedInterfaces = ["vnet1" "virbr0"];
    };

    # dconf.settings = {
    #   "org/virt-manager/virt-manager/connections" = {
    #     autoconnect = ["qemu:///system"];
    #     uris = ["qemu:///system"];
    #   };
    # };
    #https://github.com/eyeos/spice-web-client
  };
}
