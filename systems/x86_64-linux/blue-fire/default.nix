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
  isLinux = format == "linux";

  boot-into-bios = pkgs.writeShellScriptBin "boot-into-bios" ''
    sudo ${lib.getExe pkgs.ipmitool} chassis bootparam set bootflag force_bios
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
      builder.enable = true;
      hardware = {
        # tpm.enable = true;
        secure-boot.enable = true;
      };
    };

    services.tcsd.enable = true;
    boot.kernel.sysctl."net.ipv4.ip_forward" = 1;
    services.prometheus.exporters.ipmi.enable = true;

    networking = {
      networkmanager.enable = lib.mkDefault true;

      hostName = lib.mkDefault "blue-fire";
      hostId = "529fd7aa";

      firewall = {
        enable = false;
      };
      useDHCP = lib.mkDefault true;
    };

    environment.systemPackages = with pkgs; [
      # ipmicfg
      ipmiview
      ipmiutil
      # vagrant
      ipmitool
      boot-into-bios
      openipmi
    ];

    services.tailscale = {
      useRoutingFeatures = lib.mkForce "both";
    };

    services.cron.systemCronJobs = [
      # Reset 5-minute watchdog timer every minute
      "* * * * * ${lib.getExe pkgs.ipmitool} raw 0x30 0x97 1 5"
    ];

    # Minimal configuration for NFS support with Vagrant.
    # services.nfs.server.enable = true;

    # # Add firewall exception for VirtualBox provider
    # networking.firewall.extraCommands = ''
    #   ip46tables -I INPUT 1 -i vboxnet+ -p tcp -m tcp --dport 2049 -j ACCEPT
    # '';

    # # Add firewall exception for libvirt provider when using NFSv4
    # networking.firewall.interfaces."virbr1" = {
    #   allowedTCPPorts = [ 2049 ];
    #   allowedUDPPorts = [ 2049 ];
    # };

    # boot.loader.systemd-boot.enable = true;
    # boot.loader.efi.canTouchEfiVariables = true;
    nix.buildMachines = [
      {
        hostName = "localhost";
        system = "aarch64-linux";
        supportedFeatures = ["kvm" "nixos-test" "big-parallel" "benchmark"];
        maxJobs = 1;
      }
    ];
    boot = {
      binfmt.emulatedSystems = ["aarch64-linux"];

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
        "watchdog"
      ];
      extraModulePackages = [];
      # kernelParams = ["console=ttyS0,115200" "console=tty1"];
    };
  };
}
