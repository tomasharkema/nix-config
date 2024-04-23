{
  lib,
  inputs,
  pkgs,
  ...
}:
with lib; {
  imports = with inputs; [
    nixos-hardware.nixosModules.common-cpu-intel
    nixos-hardware.nixosModules.common-pc-ssd
    # (pkgs.modulesPath + "/installer/scan/not-detected.nix")
    ./hardware-configuration.nix
  ];

  config = {
    installed = true;
    # gui = {
    #   enable = true;
    #   desktop = {
    #     rdp.enable = true;
    #   };
    #   apps.steam.enable = true;
    # };
    traits = {
      # builder.enable = true;
      hardware = {
        # tpm.enable = true;
        # secure-boot.enable = true;
        remote-unlock.enable = true;
      };
    };

    services = {
      podman.enable = true;
      # freeipa.replica.enable = true;
      tcsd.enable = true;
    };

    apps.home-assistant.enable = true;

    services.xrdp.enable = true;
    services.xrdp.defaultWindowManager = "${pkgs.icewm}/bin/icewm";
    # networking.firewall.allowedTCPPorts = [3389];

    disks.btrfs = {
      enable = true;
      main = "/dev/disk/by-id/ata-Samsung_SSD_850_PRO_256GB_S39KNX0J775697K";
      media = "/dev/disk/by-id/ata-ST2000DX001-1CM164_Z1E99G1N";
      encrypt = true;
      newSubvolumes = true;
    };

    # resilio.root = "/opt/media/resilio";

    boot = {
      binfmt.emulatedSystems = ["aarch64-linux"];
      loader.systemd-boot.enable = true;
    };

    services.kmscon = {
      enable = mkForce false;
    };

    networking = {
      hostName = "arthur";
      hostId = "529fd7bb";
      useDHCP = false;
      interfaces."eno1" = {
        useDHCP = true;
        wakeOnLan.enable = true;
      };
      firewall.enable = true;
      wireless.enable = lib.mkForce false;
    };

    headless.hypervisor = {
      enable = true;
      bridgeInterfaces = ["eno1"];
    };
  };
}
