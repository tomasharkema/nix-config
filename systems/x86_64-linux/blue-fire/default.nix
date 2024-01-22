{
  # Snowfall Lib provides a customized `lib` instance with access to your flake's library
  # as well as the libraries available from your flake's inputs.
  lib,
  # An instance of `pkgs` with your overlays and packages applied is also available.
  pkgs,
  # You also have access to your flake's inputs.
  inputs,
  # Additional metadata is provided by Snowfall Lib.
  system, # The system architecture for this host (eg. `x86_64-linux`).
  target, # The Snowfall Lib target for this system (eg. `x86_64-iso`).
  format, # A normalized name for the system target (eg. `iso`).
  virtual, # A boolean to determine whether this system is a virtual target using nixos-generators.
  systems, # An attribute map of your defined hosts.
  # All other arguments come from the system system.
  config,
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

    virtualisation = {
      oci-containers.containers = {
        social-dl = {
          image = "docker.io/tomasharkema7/social-dl";
          autoStart = true;
          # ports = ["80:80" "443:443" "389:389" "636:636" "88:88" "464:464" "88:88/udp" "464:464/udp"];
          # hostname = "ipa.harkema.io";
          # extraOptions = ["--sysctl" "net.ipv6.conf.all.disable_ipv6=0"];
          # cmd = ["ipa-server-install" "-U" "-r" "HARKEMA.IO"];
          # volumes = [
          #   "/var/lib/freeipa:/data:Z"
          # ];
        };
      };
    };
  };
}
