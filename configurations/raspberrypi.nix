{ disko, nixpkgs, pkgsFor, inputs, nixos-hardware, agenix, home-manager, ... }:
let
  defaults = { pkgs, ... }: {

    imports = [ ../apps/tailscale ../apps/cockpit.nix ];

    services.openssh.enable = true;
    services.avahi.enable = true;
    console.enable = false;

    environment.systemPackages = with pkgs; [
      libraspberrypi
      raspberrypi-eeprom
    ];

    networking = {
      wireless.enable = false;
      networkmanager.enable = true;
      hostName = "raspbii";
    };

    system.stateVersion = "23.11";

    hardware.enableRedistributableFirmware = true;
    boot.loader.raspberryPi.firmwareConfig = "force_turbo=1";
    users.groups = {
      tomas = { };
      rslsync = { };
    };
    users.users = {
      tomas = {
        extraGroups = [ "wheel" "tomas" ];
        isNormalUser = true;
        openssh.authorizedKeys.keys = [
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMQkKn73qM9vjYIaFt94Kj/syd5HCw2GdpiZ3z5+Rp/r tomas@supermicro"
          "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILgD7me/mlDG89ZE/tLTJeNhbo3L+pi7eahB2rUneSR4 tomas"
        ];
      };
      rslsync = {
        group = "rslsync";
        isSystemUser = true;
      };
      root.openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMQkKn73qM9vjYIaFt94Kj/syd5HCw2GdpiZ3z5+Rp/r tomas@supermicro"
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILgD7me/mlDG89ZE/tLTJeNhbo3L+pi7eahB2rUneSR4 tomas"
      ];

    };
  };
in
{
  raspberrypi-3 = nixpkgs.lib.nixosSystem {
    system = "aarch64-linux";
    pkgs = pkgsFor."aarch64-linux";

    specialArgs = { inherit inputs; };

    modules = [
      "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64-new-kernel-no-zfs-installer.nix"
      "${nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"
      (defaults)
      agenix.nixosModules.default
      ({ pkgs, ... }: {

        environment.systemPackages = with pkgs; [
          libraspberrypi
          raspberrypi-eeprom
        ];
        system.stateVersion = "23.11";

        networking.wireless.enable = false;
        networking.networkmanager.enable = true;

        boot.initrd.kernelModules = [ "vc4" "bcm2835_dma" "i2c_bcm2835" ];
        boot.loader.grub.enable = false;
        boot.loader.generic-extlinux-compatible.enable = true;

        # services.avahi.extraServiceFiles = {
        #   ssh = "${pkgs.avahi}/etc/avahi/services/ssh.service";
        # };

        # boot.loader.raspberryPi = {
        #   enable = true;
        #   version = 3;
        #   firmwareConfig = ''
        #     core_freq=250
        #   '';
        # };

        # boot.initrd.kernelModules = [ "vc4" "bcm2835_dma" "i2c_bcm2835" ];

        hardware.enableRedistributableFirmware = true;
      })
    ];
  };

  raspbii = (nixpkgs.lib.nixosSystem {
    system = "aarch64-linux";
    pkgs = pkgsFor."aarch64-linux";

    specialArgs = { inherit inputs; };
    modules = [
      # base
      inputs.nixos-hardware.nixosModules.raspberry-pi-4
      "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64-new-kernel-no-zfs-installer.nix"
      "${nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"
      defaults
      agenix.nixosModules.default
      ../secrets
      ({ config, pkgs, lib, ... }: {

        networking.firewall = {
          enable = true;
        };

        boot.loader.raspberryPi.firmwareConfig = "force_turbo=1";
        # boot.loader.raspberryPi.enable = true;

        hardware = {
          raspberry-pi."4".apply-overlays-dtmerge.enable = true;
          deviceTree = {
            enable = true;
            filter = "*rpi-4-*.dtb";
          };
        };
      })
      # ../common/defaults.nix
      home-manager.nixosModules.home-manager
      {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.extraSpecialArgs = { inherit inputs; };
        home-manager.users.tomas.imports = [
          # nix-flatpak.homeManagerModules.nix-flatpak
          agenix.homeManagerModules.default
          ../home.nix
        ];
        home-manager.backupFileExtension = "bak";
      }
    ];
  });
}
