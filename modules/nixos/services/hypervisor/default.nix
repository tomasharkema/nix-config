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
    system.nixos.tags = ["with-hypervisor"];

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
        swtpm.enable = true;
        ovmf = {
          enable = true;
          packages = [
            pkgs.pkgsCross.aarch64-multiplatform.OVMF.fd # AAVMF
            pkgs.OVMF.fd
          ];
        };
      };
    };

    users.users.${config.user.name}.extraGroups = ["libvirtd"];
  };
}
