{
  inputs,
  nixpkgs,
  homemanager,
  ...
}: let
  defaults = {
    pkgs,
    lib,
    config,
    ...
  }: {
    imports = [
      ../common/defaults.nix
      ../apps/tailscale
      ../apps/cockpit.nix
      ../common/users.nix
      # ../common/wifi.nix
    ];

    # systemd.services.btattach = {
    #   before = ["bluetooth.service"];
    #   after = ["dev-ttyAMA0.device"];
    #   wantedBy = ["multi-user.target"];
    #   serviceConfig = {
    #     ExecStart = "${pkgs.bluez}/bin/btattach -B /dev/ttyAMA0 -P bcm -S 3000000";
    #   };
    # };
  };
in {
  baaa-express = nixpkgs.lib.nixosSystem {
    system = "aarch64-linux";

    specialArgs = {inherit inputs;};

    modules = with inputs;
      [
        # nixos-generators.nixosModules.all-formats
        "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
        "${nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"
        agenix.nixosModules.default

        # disko.nixosModules.default
        # ../common/disks/tmpfs.nix
        # {
        # _module.args.disks = ["/dev/disk/by-label/NIXOS_SD"];
        # }
        ../secrets
        defaults
        ({
          pkgs,
          lib,
          ...
        }: {
          sdImage.compressImage = false;

          environment.systemPackages = with pkgs; [
            libraspberrypi
            raspberrypi-eeprom
          ];
          system.stateVersion = "23.11";

          # boot.kernelParams = [
          #   "console=ttyS1,115200n8"
          #   "cma=320M"
          # ];

          # fileSystems."/".fsType = lib.mkForce "tmpfs";
          # fileSystems."/".device = lib.mkForce "none";

          boot.initrd.kernelModules = ["vc4" "bcm2835_dma" "i2c_bcm2835"];

          networking.hostName = "baaa-express";
          # boot.loader.raspberryPi = {
          #   enable = true;
          #   version = 3;
          #   firmwareConfig = ''
          #     core_freq=250
          #   '';
          # };

          systemd.services.btattach = {
            before = ["bluetooth.service"];
            after = ["dev-ttyAMA0.device"];
            wantedBy = ["multi-user.target"];
            serviceConfig = {
              ExecStart = "${pkgs.bluez}/bin/btattach -B /dev/ttyAMA0 -P bcm -S 3000000";
            };
          };
        })
      ]
      ++ homemanager;
  };

  pegasus = nixpkgs.lib.nixosSystem {
    system = "aarch64-linux";

    specialArgs = {inherit inputs;};

    modules = with inputs;
      [
        # base
        nixos-hardware.nixosModules.raspberry-pi-4
        "${nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64-new-kernel-no-zfs-installer.nix"
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

          hardware = {
            raspberry-pi."4" = {
              apply-overlays-dtmerge.enable = true;
              dwc2.enable = true;
              fkms-3d.enable = true;
            };
            deviceTree = {
              enable = true;
              # filter = "*rpi-4-*.dtb";
            };
          };
          networking.hostName = "pegasus";
        })
      ]
      ++ homemanager;
  };
}
