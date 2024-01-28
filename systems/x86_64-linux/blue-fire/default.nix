{
  lib,
  pkgs,
  inputs,
  ...
}: let
  boot-into-bios = pkgs.writeShellScriptBin "boot-into-bios" ''
    sudo ${pkgs.ipmitool}/bin/ipmitool chassis bootparam set bootflag force_bios
  '';
in {
  # Your configuration.

  imports = with inputs; [
    ./hardware-configuration.nix

    nixos-hardware.nixosModules.common-cpu-intel
    nixos-hardware.nixosModules.common-pc-ssd
    nixos-hardware.nixosModules.supermicro-x10sll-f
  ];

  config = {
    disks.btrfs = {
      enable = true;
      main = "/dev/disk/by-id/ata-Samsung_SSD_850_EVO_500GB_S21JNXBGC17548K";
      media = "/dev/disk/by-id/ata-TOSHIBA_MK3263GSXN_5066P0YHT";
    };

    traits = {
      builder = {
        enable = true;
        hydra.enable = true;
      };
    };

    services.tcsd.enable = true;
    boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
    services.prometheus.exporters.ipmi.enable = true;

    headless.enable = true;

    apps.podman.enable = true;

    networking = {
      networkmanager.enable = lib.mkDefault false;

      hostName = lib.mkDefault "blue-fire";
      hostId = "529fd7aa";

      firewall = {
        enable = false;
      };
      useDHCP = lib.mkDefault true;
    };

    environment.systemPackages = with pkgs; [
      # ipmicfg
      # ipmiview
      # ipmiutil
      # vagrant
      ipmitool
      boot-into-bios
      # openipmi
    ];

    services.tailscale = {
      useRoutingFeatures = lib.mkForce "both";
    };

    services.nfs = {
      server = {
        enable = true;
        exports = ''
          /export/media        192.168.1.170(rw,fsid=0,no_subtree_check)
        '';
      };
    };

    fileSystems."/export/media" = {
      device = "/media";
      options = ["bind"];
    };

    fileSystems."/mnt/unraid/appdata" = {
      device = "192.168.0.100:/mnt/user/appdata";
      fsType = "nfs";
    };
    fileSystems."/mnt/unraid/appdata_ssd" = {
      device = "192.168.0.100:/mnt/user/appdata_ssd";
      fsType = "nfs";
    };
    fileSystems."/mnt/unraid/appdata_disk" = {
      device = "192.168.0.100:/mnt/user/appdata_disk";
      fsType = "nfs";
    };
    fileSystems."/mnt/dione" = {
      device = "192.168.178.3:/volume1/homes";
      fsType = "nfs";
    };

    networking.interfaces."eno1".mtu = 9000;

    boot = {
      binfmt.emulatedSystems = ["aarch64-linux"];

      loader = {
        systemd-boot.enable = true;
        efi.canTouchEfiVariables = true;
        systemd-boot.configurationLimit = 10;
      };

      initrd = {
        availableKernelModules = ["xhci_pci" "ahci" "usbhid" "usb_storage" "sd_mod"];
        kernelModules = [
          "kvm-intel"
          "uinput"
          "nvme"
          # "tpm_rng"
          "ipmi_ssif"
          "acpi_ipmi"
          "ipmi_si"
          "ipmi_devintf"
          "ipmi_msghandler"
        ];
      };
      kernelModules = [
        "kvm-intel"
        "uinput"
        "nvme"
        "tpm_rng"
        "ipmi_ssif"
        "acpi_ipmi"
        "ipmi_si"
        "ipmi_devintf"
        "ipmi_msghandler"
        # "watchdog"
      ];
      extraModulePackages = [];
      # kernelParams = ["console=ttyS0,115200" "console=tty1"];
    };

    # virtualisation = {
    # oci-containers.containers = {
    # social-dl = {
    #   image = "docker.io/tomasharkema7/social-dl";
    #   autoStart = true;
    #   # ports = ["80:80" "443:443" "389:389" "636:636" "88:88" "464:464" "88:88/udp" "464:464/udp"];
    #   # hostname = "ipa.harkema.io";
    #   # extraOptions = ["--sysctl" "net.ipv6.conf.all.disable_ipv6=0"];
    #   # cmd = ["ipa-server-install" "-U" "-r" "HARKEMA.IO"];
    #   # volumes = [
    #   #   "/var/lib/freeipa:/data:Z"
    #   # ];
    # };
    # };
    # };
  };
}
