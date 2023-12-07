{
  nixConfig = {
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
    cachix-deploy-flake.url = "github:cachix/cachix-deploy-flake";
    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    agenix.url = "github:ryantm/agenix";
    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, nixos-generators, ... }:
    let
      supportedSystems =
        [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
      forAllSystems = nixpkgs.lib.genAttrs supportedSystems;
      nixpkgsFor = forAllSystems (system: import nixpkgs { inherit system; });
    in {

      nixpkgs.config.allowUnfree = true;
      nixpkgs.config.allowUnfreePredicate = _: true;

      colmena = {
        meta = {
          machinesFile = /etc/nix/machines;
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

        enceladus = import ./machines/enceladus/default.nix;

        utm-nixos = import ./machines/utm-nixos.nix;

        # utm-ferdorie = { pkgs, modulesPath, ... }: {

        #   imports = [ ./overlays/desktop.nix ];

        #   networking.hostName = "utm-ferdorie";
        #   deployment.tags = [ "vm" ];
        #   nixpkgs.system = "aarch64-linux";
        #   deployment = {
        #     targetHost = "100.119.250.94";
        #     targetUser = "tomas";
        #   };
        #   boot.isContainer = true;
        # };

        hyperv-nixos = { pkgs, ... }: {
          nixpkgs.system = "x86_64-linux";
          imports = [
            ./overlays/desktop.nix
            # ./overlays/efi.nix
          ];

          networking.hostName = "hyperv-nixos";
          deployment.tags = [ "vm" ];

          deployment = {
            targetHost = "100.64.161.30";
            # targetHost = "192.168.1.73";
            targetUser = "root";
          };

          virtualisation.hypervGuest.enable = true;

          boot.loader.systemd-boot.enable = true;
          boot.loader.efi.canTouchEfiVariables = true;
          boot.initrd.availableKernelModules = [ "sd_mod" "sr_mod" ];
          boot.initrd.kernelModules = [ ];
          boot.kernelModules = [ ];
          boot.extraModulePackages = [ ];

          fileSystems."/" = {
            device = "/dev/disk/by-uuid/2aa478a5-ccd9-4023-95a1-daecfd13f18b";
            fsType = "ext4";
          };

          fileSystems."/boot" = {
            device = "/dev/disk/by-uuid/888B-3762";
            fsType = "vfat";
          };

          swapDevices = [ ];

        };

        cfserve = { pkgs, modulesPath, ... }: {
          nixpkgs.system = "x86_64-linux";
          imports = [
            (modulesPath + "/installer/scan/not-detected.nix")
            ./overlays/desktop.nix
            ./apps/steam.nix
            # ./overlays/efi.nix  
          ];

          deployment.tags = [ "bare" ];
          networking.hostName = "cfserve";

          deployment = {
            # targetHost = "cfserve.ling-lizard.ts.net";
            targetHost = "100.111.187.38";
            # targetHost = "192.168.2.199";
            targetUser = "root";
          };

          boot.loader.systemd-boot.enable = true;
          boot.loader.efi.canTouchEfiVariables = true;
          boot.initrd.availableKernelModules =
            [ "ehci_pci" "ahci" "usb_storage" "usbhid" "sd_mod" ];
          boot.initrd.kernelModules = [ ];
          boot.kernelModules = [ "kvm-intel" ];
          boot.extraModulePackages = [ ];

          fileSystems."/" = {
            device = "/dev/disk/by-uuid/ebc58c28-a634-468e-b5e8-67da630aa1ef";
            fsType = "ext4";
          };

          fileSystems."/boot" = {
            device = "/dev/disk/by-uuid/FBE1-15BC";
            fsType = "vfat";
          };
        };

        unraidferdorie = { pkgs, modulesPath, ... }: {
          nixpkgs.system = "x86_64-linux";

          imports = [
            (modulesPath + "/profiles/qemu-guest.nix")
            # ./overlays/qemu.nix
            ./overlays/desktop.nix
            # ./overlays/efi.nix 
          ];

          deployment.tags = [ "vm" ];
          networking.hostName = "unraidferdorie";
          deployment = {
            targetHost = "100.85.77.114";
            # targetHost = "192.168.0.18";
            targetUser = "root";
          };

          boot.loader.systemd-boot.enable = true;
          boot.loader.efi.canTouchEfiVariables = true;
          boot.initrd.availableKernelModules =
            [ "uhci_hcd" "ehci_pci" "ahci" "virtio_pci" "sr_mod" "virtio_blk" ];
          boot.initrd.kernelModules = [ ];
          boot.kernelModules = [ "kvm-intel" ];
          boot.extraModulePackages = [ ];

          fileSystems."/" = {
            device = "/dev/disk/by-uuid/7cfeeb6a-9324-4e8c-ad49-99a2dacba295";
            fsType = "ext4";
          };

          fileSystems."/boot" = {
            device = "/dev/disk/by-uuid/A890-75D3";
            fsType = "vfat";
          };
        };

        tactical = { pkgs, ... }: {
          nixpkgs.system = "x86_64-linux";

          imports = [
            # ./overlays/qemu.nix
            # ./overlays/desktop.nix
            # ./overlays/efi.nix 
          ];

          deployment.tags = [ "vm" ];
          networking.hostName = "tactical";
          deployment = {
            targetHost = "100.83.189.162";
            # targetHost = "192.168.0.32";
            targetUser = "root";
          };
          boot.isContainer = true;
        };
      };

      packages = forAllSystems (system:
        let pkgs = nixpkgsFor.${system};
        in {
          utmiso = nixos-generators.nixosGenerate {
            system = "aarch64-linux";
            modules = [
              # "${nixos}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
              ./overlays/defaults.nix
              ./machines/utm-nixos.nix
            ];
            format = "qcow";
          };
          enceladusiso = nixos-generators.nixosGenerate {
            system = "x86_64-linux";
            modules = [
              # "${nixos}/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix"
              ./overlays/defaults.nix
              ./machines/enceladus/default.nix
            ];
            format = "install-iso";
          };
        });
    };
}
