{lib, ...}: {
  imports = [
    ./hardware-configuration.nix
  ];

  config = {
    gui.enable = true;
    gui.apps.steam.enable = true;

    networking.hostName = "wodan-vm";
    networking.hostId = "a5a1dad6";

    traits = {
      hardware = {
        tpm.enable = true;
        secure-boot.enable = true;
      };
    };
    boot.bootspec.enable = true;

    services.resilio = {
      enable = lib.mkForce false;
    };

    networking.firewall = {
      enable = false;
      # enable = true;
    };

    fileSystems."/".device = lib.mkDefault "/dev/sda";
  };
}
