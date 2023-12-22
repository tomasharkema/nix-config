{ disko
, nixpkgs
, pkgsFor
, inputs
, nixos-hardware
, agenix
, home-manager
, impermanence
, nixos-generators
, homemanager
, ...
}:
let
  defaults = { pkgs, lib, config, ... }@attrs:
    let
      rpi-update-src = pkgs.fetchFromGitHub {
        owner = "raspberrypi";
        repo = "rpi-update";
        rev = "e85c4b69065260496c138b82b68566217dc89ad0";
        hash = "sha256-D+9ERc8z5sOk3hSKh8udczTREg3VcHGMYjdwoAsPvoM=";
      };
      rpi-update = pkgs.writeShellScriptBin "rpi-update" ''
        exec ${rpi-update-src}/rpi-update
      '';
    in
    {

      imports = [
        ../common/defaults.nix
        ../apps/tailscale
        ../apps/cockpit.nix
        ../common/users.nix
        ../common/wifi.nix
      ];

      services.openssh.enable = true;
      services.avahi.enable = true;
      console.enable = false;

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
      boot.loader.raspberryPi.firmwareConfig = "force_turbo=1";

      hardware.enableRedistributableFirmware = true;

      services.avahi.extraServiceFiles = {
        ssh = "${pkgs.avahi}/etc/avahi/services/ssh.service";
      };
      services.avahi.publish.userServices = true;

      # users.groups = {
      #   tomas = { };
      #   rslsync = { };
      # };
      # users.users = {
      #   tomas = {
      #     extraGroups = [ "wheel" "tomas" ];
      #     isNormalUser = true;
      #     openssh.authorizedKeys.keys = [
      #       "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMQkKn73qM9vjYIaFt94Kj/syd5HCw2GdpiZ3z5+Rp/r tomas@blue-fire"
      #       "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILgD7me/mlDG89ZE/tLTJeNhbo3L+pi7eahB2rUneSR4 tomas"
      #       "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJRn81Pxfg4ttTocQnTUWirpC1QVeJ5bfPC63ET9fNVa root@blue-fire"
      #     ];
      #   };
      #   rslsync = {
      #     group = "rslsync";
      #     isSystemUser = true;
      #   };
      #   root.openssh.authorizedKeys.keys = [
      #     "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMQkKn73qM9vjYIaFt94Kj/syd5HCw2GdpiZ3z5+Rp/r tomas@blue-fire"
      #     "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILgD7me/mlDG89ZE/tLTJeNhbo3L+pi7eahB2rUneSR4 tomas"
      #     "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJRn81Pxfg4ttTocQnTUWirpC1QVeJ5bfPC63ET9fNVa root@blue-fire"
      #   ];

      # };
    };
in
{
  baaa-express = nixpkgs.lib.nixosSystem {
    system = "aarch64-linux";
    pkgs = pkgsFor."aarch64-linux";

    specialArgs = { inherit inputs; };

    modules = [
      nixos-generators.nixosModules.all-formats
      "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
      "${nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"
      impermanence.nixosModules.impermanence
      agenix.nixosModules.default
      ../secrets
      (defaults)
      ({ pkgs, lib, ... }: {

        environment.systemPackages = with pkgs; [
          libraspberrypi
          raspberrypi-eeprom
        ];
        system.stateVersion = "23.11";

        boot.kernelParams = [
          "console=ttyS1,115200n8"
          "cma=320M"
        ];

        boot.initrd.kernelModules = [ "vc4" "bcm2835_dma" "i2c_bcm2835" ];
        boot.loader.grub.enable = false;
        boot.loader.generic-extlinux-compatible.enable = true;
        networking.hostName = "baaa-express";

        hardware.enableRedistributableFirmware = true;

        environment.persistence."/nix/persistent" = {
          hideMounts = true;
          directories = [
            "/var/log"
            "/var/lib/bluetooth"
            "/var/lib/nixos"
            "/var/lib/systemd/coredump"
            "/etc/NetworkManager/system-connections"
            { directory = "/var/lib/colord"; user = "colord"; group = "colord"; mode = "u=rwx,g=rx,o="; }
          ];
          files = [
            "/etc/machine-id"
            { file = "/etc/nix/id_rsa"; parentDirectory = { mode = "u=rwx,g=,o="; }; }
          ];
        };

        fileSystems."/" = {
          device = lib.mkForce "none";
          fsType = lib.mkForce "tmpfs";
          autoResize = lib.mkForce false;
          options = [ "defaults" "size=25%" "mode=755" ];
        };

        fileSystems."/nix" = {
          device = "/dev/mmcblk0";
          fsType = "btrfs";
          options = [ "compress-force=zstd" ];
        };

        fileSystems."/boot" = {
          device = "/dev/disk/by-uuid/2178-694E";
          fsType = "vfat";
        };
      })
    ] ++ homemanager;
  };

  pegasus = (nixpkgs.lib.nixosSystem {
    system = "aarch64-linux";
    pkgs = pkgsFor."aarch64-linux";
    specialArgs = { inherit inputs; };

    modules = [
      # base
      inputs.nixos-hardware.nixosModules.raspberry-pi-4
      "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
      "${nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"
      defaults
      agenix.nixosModules.default

      ../secrets

      ({ config, pkgs, lib, ... }: {

        networking.firewall = {
          enable = true;
        };
        # boot.loader.raspberryPi.enable = true;

        hardware = {
          raspberry-pi."4".apply-overlays-dtmerge.enable = true;
          deviceTree = {
            enable = true;
            filter = "*rpi-4-*.dtb";
          };
        };
        networking.hostName = "pegasus";
      })
    ] ++ homemanager;
  });
}
