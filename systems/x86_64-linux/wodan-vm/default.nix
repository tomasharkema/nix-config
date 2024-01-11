{lib, ...}: {
  imports = [
    ./hardware-configuration.nix
  ];

  config = {
    gui.enable = true;

    networking.hostName = "wodan-vm";
    networking.hostId = "a5a1dad6";
    services.resilio = {
      enable = lib.mkForce false;
    };
    traits = {
      hardware = {
        tpm.enable = true;
        secure-boot.enable = true;
      };
    };
    boot.bootspec.enable = true;

    networking.firewall.enable = false;
    networking.nftables.enable = lib.mkForce false;
    networking.wireless.enable = lib.mkDefault false;
  };
}
