{
  disko,
  nixpkgs,
  pkgsFor,
  inputs,
  nixos-hardware,
  agenix,
  home-manager,
  impermanence,
  nixos-generators,
  homemanager,
  ...
}: let
  defaults = {
    pkgs,
    lib,
    config,
    ...
  } @ attrs: let
    rpi-update-src = pkgs.fetchFromGitHub {
      owner = "raspberrypi";
      repo = "rpi-update";
      rev = "e85c4b69065260496c138b82b68566217dc89ad0";
      hash = "sha256-D+9ERc8z5sOk3hSKh8udczTREg3VcHGMYjdwoAsPvoM=";
    };
    rpi-update = pkgs.writeShellScriptBin "rpi-update" ''
      exec ${rpi-update-src}/rpi-update
    '';
  in {
    imports = [
      ../common/defaults.nix
      ../apps/tailscale
      ../apps/cockpit.nix
      ../common/users.nix
      # ../common/wifi.nix
    ];

    sdImage.compressImage = false;

    # NixOS wants to enable GRUB by default
    boot.loader.grub.enable = false;
    # Enables the generation of /boot/extlinux/extlinux.conf
    boot.loader.generic-extlinux-compatible.enable = true;

    # !!! Set to specific linux kernel version
    # boot.kernelPackages = pkgs.linuxPackages_5_4;

    services.openssh.enable = true;
    services.avahi.enable = true;
    console.enable = true;

    environment.systemPackages = with pkgs; [
      libraspberrypi
      raspberrypi-eeprom
      rpi-update
    ];

    systemd.services.attic-watch.enable = lib.mkForce false;

    services.resilio = {
      enable = lib.mkForce false;
    };

    system.stateVersion = "23.11";
    boot.loader.raspberryPi.firmwareConfig = "force_turbo=1,dtoverlay=dwc2";
    # boot.loader.raspberryPi.enable = true;
    boot.loader.raspberryPi.uboot.enable = true;

    services.avahi.extraServiceFiles = {
      ssh = "${pkgs.avahi}/etc/avahi/services/ssh.service";
    };
    services.avahi.publish.userServices = true;

    hardware = {
      enableRedistributableFirmware = true;
      firmware = [pkgs.wireless-regdb];
    };

  networking.networkmanager.enable = false;

    # Networking
    networking = {
      useDHCP = true;
      interfaces.wlan0 = {
        useDHCP = true;
      };
      interfaces.eth0 = {
        useDHCP = true;
        # I used DHCP because sometimes I disconnect the LAN cable
        #ipv4.addresses = [{
        #  address = "192.168.100.3";
        #  prefixLength = 24;
        #}];
      };

      # Enabling WIFI
      wireless.enable = true;
      wireless.interfaces = ["wlan0"];
      # If you want to connect also via WIFI to your router

      wireless.networks."Have a good day".psk = "0fcc36c0dd587f3d85028f427c872fead0b6bb7623099fb4678ed958f2150e23";

      # You can set default nameservers
      nameservers = ["1.1.1.1" "1.0.0.1"];
      # You can set default gateway
      defaultGateway = {
        address = "192.168.178.1";
        interface = "wlan0";
      };
      firewall = {
        enable = lib.mkForce false;
      };
    };
  };
in {
  baaa-express = nixpkgs.lib.nixosSystem {
    system = "aarch64-linux";

    specialArgs = {inherit inputs;};

    modules =
      [
        nixos-generators.nixosModules.all-formats
        "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
        "${nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"
        impermanence.nixosModules.impermanence
        agenix.nixosModules.default
        # disko.nixosModules.default
        ../secrets
        defaults
        ({
          pkgs,
          lib,
          ...
        }: {
          environment.systemPackages = with pkgs; [
            libraspberrypi
            raspberrypi-eeprom
          ];
          system.stateVersion = "23.11";

          boot.kernelParams = [
            "console=ttyS1,115200n8"
            "cma=320M"
          ];

          boot.initrd.kernelModules = ["vc4" "bcm2835_dma" "i2c_bcm2835"];
          boot.loader.grub.enable = false;
          boot.loader.generic-extlinux-compatible.enable = true;

          networking.hostName = "baaa-express";

          # fileSystems."/" = {
          #   device = lib.mkForce "none";
          #   fsType = lib.mkForce "tmpfs";
          #   options = [ "defaults" "size=25%" "mode=755" ];
          # };

          # fileSystems."/nix" = {
          #   device = "/dev/disk/by-label/NIXOS_SD";
          #   fsType = "ext4";
          # };

          # fileSystems."/boot" = {
          #   device = "/dev/disk/by-uuid/XXXX-XXXX";
          #   fsType = "vfat";
          # };

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
        })
      ]
      ++ homemanager;
  };

  pegasus = nixpkgs.lib.nixosSystem {
    system = "aarch64-linux";

    specialArgs = {inherit inputs;};

    modules =
      [
        # base
        inputs.nixos-hardware.nixosModules.raspberry-pi-4
        "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
        "${nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"
        defaults
        agenix.nixosModules.default

        ../secrets

        ({
          config,
          pkgs,
          lib,
          ...
        }: {
          # boot.loader.raspberryPi.enable = true;

          hardware = {
            raspberry-pi."4".apply-overlays-dtmerge.enable = true;
            deviceTree = {
              enable = true;
              filter = "*rpi-4-*.dtb";
            };
          };
          networking.hostName = "pegasus";
hardware.raspberry-pi."4".dwc2.enable = true;
        })
      ]
      ++ homemanager;
  };
}
