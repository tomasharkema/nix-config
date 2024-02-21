{
  lib,
  inputs,
  ...
}: {
  imports = with inputs; [
    nixos-hardware.nixosModules.common-cpu-intel
    nixos-hardware.nixosModules.common-pc-ssd
    # (pkgs.modulesPath + "/installer/scan/not-detected.nix")
    ./hardware-configuration.nix
  ];

  config = {
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
        secure-boot.enable = true;
        remote-unlock.enable = true;
      };
    };

    services.freeipa.replica.enable = true;

    disks.btrfs = {
      enable = true;
      main = "/dev/disk/by-id/ata-Samsung_SSD_850_PRO_256GB_S39KNX0J775697K";
      media = "/dev/disk/by-id/ata-ST2000DX001-1CM164_Z1E99G1N";
      encrypt = true;
    };

    resilio.root = "/media/resilio";

    boot.binfmt.emulatedSystems = ["aarch64-linux"];

    networking = {
      hostName = "arthur";
      hostId = "529fd7bb";
      useDHCP = lib.mkDefault true;
      interfaces."eno1".wakeOnLan.enable = true;
      # firewall.enable = true;
      wireless.enable = lib.mkForce false;
    };

    services.tcsd.enable = true;

    # environment.persistence."/nix/persistent" = {
    #   hideMounts = true;
    #   directories = [
    #     "/var/log"
    #     "/var/lib/bluetooth"
    #     "/var/lib/nixos"
    #     "/var/lib/systemd/coredump"
    #     "/etc/NetworkManager/system-connections"
    #     {
    #       directory = "/var/lib/colord";
    #       user = "colord";
    #       group = "colord";
    #       mode = "u=rwx,g=rx,o=";
    #     }
    #   ];
    #   files = [
    #     "/etc/machine-id"
    #     {
    #       file = "/etc/nix/id_rsa";
    #       parentDirectory = {mode = "u=rwx,g=,o=";};
    #     }
    #   ];
    # };
  };
}
