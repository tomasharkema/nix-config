{lib, ...}: {
  imports = [
    ./hardware-configuration.nix
  ];

  config = {
    gui.enable = true;
    gui.apps.steam.enable = true;

    networking.hostName = "wodan-vm";
    networking.hostId = "a5a1dad6";

    services.resilio = {
      enable = lib.mkForce false;
    };
    boot.growPartition = true;

    # deployment.tags = [ "vm" ];
    # deployment = {
    #   targetHost = "100.64.161.30";
    #   # targetHost = "192.168.1.73";
    #   targetUser = "root";
    # };

    boot.bootspec.enable = true;

    boot.loader.grub.enable = lib.mkDefault true;
    boot.loader.grub.efiSupport = true;
    boot.loader.grub.efiInstallAsRemovable = true;
    boot.loader.grub.devices = ["nodev"];

    networking.firewall = {
      enable = false;
      # enable = true;
    };

    fileSystems."/".device = lib.mkDefault "/dev/sda";
  };
}
