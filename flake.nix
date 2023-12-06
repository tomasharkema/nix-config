{
  nixConfig = {
    extra-substituters = [ "https://nix-community.cachix.org" ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
    extra-experimental-features = "nix-command flakes";
    distributedBuilds = true;
    buildMachines = /etc/nix/machines;
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";

    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    nixos-wsl.url = "github:nix-community/NixOS-WSL";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, ... }: {

    nixpkgs.config.allowUnfree = true;
    nixpkgs.config.allowUnfreePredicate = _: true;

    colmena = {
      meta = {
        nixpkgs = import nixpkgs {
          system = "x86_64-linux";
          overlays = [ ];
        };
        nodeNixpkgs = {
          utm = import nixpkgs {
            system = "aarch64-linux";
            overlays = [ ];
          };
        };
      };

      defaults = import ./overlays/defaults.nix;

      utm-nixos = { pkgs, ... }: {
        nixpkgs.system = "aarch64-linux";

        networking.hostName = "utm-nixos";
        deployment.tags = [ "vm" ];
        deployment.buildOnTarget = true;
        deployment = {
          # targetHost = "100.121.109.15";
          targetHost = "10.211.70.5";
          targetUser = "root";
        };

        fileSystems."/" = {
          device = "/dev/disk/by-uuid/9df616f9-99d6-4014-a814-cc88cf15e604";
          fsType = "ext4";
        };
        fileSystems."/boot" = {
          device = "/dev/disk/by-uuid/050C-ACFA";
          fsType = "vfat";
        };
        boot.loader = {
          efi = {
            canTouchEfiVariables = true;
            efiSysMountPoint = "/boot/efi"; # ← use the same mount point here.
          };
          grub = {
            efiSupport = true;
            #efiInstallAsRemovable = true; # in case canTouchEfiVariables doesn't work for your system
            device = "nodev";
          };
        };
      };

      # utm-ferdorie = { pkgs, modulesPath, ... }: {

      #   imports = [ ./overlays/desktop.nix ];

      #   networking.hostName = "utm-ferdorie";
      #   deployment.tags = [ "vm" ];
      #   nixpkgs.system = "aarch64-linux";
      # deployment.buildOnTarget = true;
      #   deployment = {
      #     targetHost = "100.119.250.94";
      #     targetUser = "tomas";
      #   };
      #   boot.isContainer = true;
      # };

      enceladus = { pkgs, ... }: {
        nixpkgs.system = "x86_64-linux";
        networking.hostName = "enceladus";
        deployment.tags = [ "bare" ];
        deployment.buildOnTarget = true;
        deployment = {
          targetHost = "100.93.81.142";
          targetUser = "root";
        };
        boot.isContainer = true;
      };

      hyperv-nixos = { pkgs, ... }: {
        nixpkgs.system = "x86_64-linux";
        imports = [
          ./overlays/desktop.nix
          # ./overlays/efi.nix
        ];

        networking.hostName = "hyperv-nixos";
        deployment.tags = [ "vm" ];

        # deployment.buildOnTarget = true;
        deployment = {
          targetHost = "100.64.161.30";
          # targetHost = "192.168.1.73";
          targetUser = "root";
        };

        virtualisation.hypervGuest.enable = true;
        boot.isContainer = true;

        # fileSystems."/" = {
        #   device = "/dev/disk/by-uuid/2aa478a5-ccd9-4023-95a1-daecfd13f18b";
        #   fsType = "ext4";
        # };

        # fileSystems."/boot" = {
        #   device = "/dev/disk/by-uuid/888B-3762";
        #   fsType = "vfat";
        # };

      };

      cfserve = { pkgs, ... }: {
        nixpkgs.system = "x86_64-linux";
        imports = [
          ./overlays/desktop.nix
          # ./overlays/efi.nix
        ];

        deployment.tags = [ "bare" ];
        networking.hostName = "cfserve";

        deployment.buildOnTarget = true;
        deployment = {
          # targetHost = "cfserve.ling-lizard.ts.net";
          targetHost = "100.111.187.38";
          targetUser = "root";
        };

        boot.isContainer = true;
        # fileSystems."/" = {
        #   device = "/dev/disk/by-uuid/97fe5fc1-27d8-4b20-aae4-887a36ceeb8a";
        #   fsType = "ext4";
        # };

        # fileSystems."/boot" = {
        #   device = "/dev/disk/by-uuid/D5F0-2E92";
        #   fsType = "vfat";
        # };
      };

      unraidferdorie = { pkgs, ... }: {
        nixpkgs.system = "x86_64-linux";

        imports = [
          # ./overlays/qemu.nix
          # ./overlays/desktop.nix
          # ./overlays/efi.nix 
        ];

        deployment.tags = [ "vm" ];
        networking.hostName = "unraidferdorie";

        deployment.buildOnTarget = true;
        deployment = {
          # targetHost = "100.81.109.156";
          targetHost = "192.168.0.18";
          targetUser = "root";
        };

        # boot.isContainer = true;

        fileSystems."/" = {
          device = "/dev/disk/by-uuid/f8f42369-5819-400d-b0c6-7417a49c19c7";
          fsType = "ext4";
        };

        fileSystems."/boot" = {
          device = "/dev/disk/by-uuid/364B-7CC3";
          fsType = "vfat";
        };
        swapDevices = [ ];

        boot.loader = {
          efi = {
            canTouchEfiVariables = true;
            efiSysMountPoint = "/boot/efi"; # ← use the same mount point here.
          };
          grub = {
            efiSupport = true;
            #efiInstallAsRemovable = true; # in case canTouchEfiVariables doesn't work for your system
            device = "nodev";
          };
        };
      };
    };
  };
}
