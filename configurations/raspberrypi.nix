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

    # NixOS wants to enable GRUB by default
    boot.loader.grub.enable = false;

    services.openssh.enable = true;
    services.avahi.enable = true;
    console.enable = true;

    environment.systemPackages = with pkgs; [
      rpi-update
      libraspberrypi
      raspberrypifw
    ];

    systemd.services.attic-watch.enable = lib.mkForce false;

    services.resilio = {
      enable = lib.mkForce false;
    };
    services.promtail = {
      enable = lib.mkForce false;
    };

    system.stateVersion = "23.11";

    services.avahi.extraServiceFiles = {
      ssh = "${pkgs.avahi}/etc/avahi/services/ssh.service";
    };
    services.avahi.publish.userServices = true;

    hardware = {
      enableRedistributableFirmware = true;
      firmware = [pkgs.wireless-regdb];
    };

    networking.networkmanager.enable = false;

    boot.loader.raspberryPi.firmwareConfig = ''
      dtparam=audio=on
    '';

    # Networking
    networking = {
      useDHCP = true;
      interfaces.wlan0 = {
        useDHCP = true;
      };
      interfaces.eth0 = {
        useDHCP = true;
      };

      # Enabling WIFI
      wireless.enable = true;
      wireless.interfaces = ["wlan0"];

      wireless.networks."Have a good day".psk = "HungryOwl456";

      firewall = {
        enable = lib.mkForce false;
      };
    };

    systemd.services.btattach = {
      before = ["bluetooth.service"];
      after = ["dev-ttyAMA0.device"];
      wantedBy = ["multi-user.target"];
      serviceConfig = {
        ExecStart = "${pkgs.bluez}/bin/btattach -B /dev/ttyAMA0 -P bcm -S 3000000";
      };
    };
  };
in {
  baaa-express = nixpkgs.lib.nixosSystem {
    system = "aarch64-linux";

    specialArgs = {inherit inputs;};

    modules =
      [
        # nixos-generators.nixosModules.all-formats
        "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
        "${nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"
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

          networking.hostName = "baaa-express";
          # boot.loader.raspberryPi = {
          #   enable = true;
          #   version = 3;
          #   firmwareConfig = ''
          #     core_freq=250
          #   '';
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
          environment.systemPackages = with pkgs; [
            raspberrypi-eeprom
          ];
          # boot.loader.raspberryPi.enable = true;

          # hardware = {
          #   raspberry-pi."4".apply-overlays-dtmerge.enable = true;
          #   deviceTree = {
          #     enable = true;
          #     filter = "*rpi-4-*.dtb";
          #   };
          # };
          networking.hostName = "pegasus";
          hardware.raspberry-pi."4".dwc2.enable = true;
        })
      ]
      ++ homemanager;
  };
}
