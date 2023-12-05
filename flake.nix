{
  nixConfig = {
    extra-substituters = [ "https://nix-community.cachix.org" ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
    extra-experimental-features = "nix-command flakes";
  };

  inputs =
    { # Pin our primary nixpkgs repository. This is the main nixpkgs repository
      # we'll use for our configurations. Be very careful changing this because
      # it'll impact your entire system.
      nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";

      # We use the unstable nixpkgs repo for some packages.
      # nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

      # Build a custom WSL installer
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

      defaults = { pkgs, ... }: {
        imports = [ ./overlays/packages.nix ./overlays/defaults.nix ];
        nix = {
          package = pkgs.nixFlakes;
          extraOptions = ''
            experimental-features = nix-command flakes
          '';
        };
      };

      utm-nixos = { pkgs, modulesPath, ... }: {
        imports = [
          # ./overlays/qemu.nix
          ./overlays/desktop.nix
          # /overlays/efi.nix
        ];

        networking.hostName = "utm-nixos";
        deployment.tags = [ "vm" ];
        nixpkgs.system = "aarch64-linux";
        deployment.buildOnTarget = true;
        deployment = {
          # targetHost = "100.127.158.59";
          targetHost = "10.211.70.5";
          targetUser = "root";
        };
        boot.isContainer = true;
        # fileSystems."/" = {
        #   device = "/dev/disk/by-uuid/88fdc8e4-3ab1-4e0f-8412-dd6077548fc4";
        #   fsType = "ext4";
        # };

        # fileSystems."/boot" = {
        #   device = "/dev/disk/by-uuid/749B-E070";
        #   fsType = "vfat";
        # };
      };

      # utm-ferdorie = { pkgs, modulesPath, ... }: {

      #   imports = [ ./overlays/desktop.nix ];

      #   networking.hostName = "utm-ferdorie";
      #   deployment.tags = [ "vm" ];
      #   nixpkgs.system = "aarch64-linux";
      #   deployment.buildOnTarget = true;
      #   deployment = {
      #     targetHost = "100.119.250.94";
      #     targetUser = "tomas";
      #   };
      #   boot.isContainer = true;
      # };

      enceladus = { pkgs, ... }: {
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
        imports = [
          ./overlays/desktop.nix
          # ./overlays/efi.nix
        ];

        networking.hostName = "hyperv-nixos";
        deployment.tags = [ "vm" ];

        deployment.buildOnTarget = true;
        deployment = {
          # targetHost = "100.64.161.30";
          targetHost = "192.168.1.73";
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
        imports = [
          ./overlays/desktop.nix
          # ./overlays/efi.nix
        ];

        deployment.tags = [ "bare" ];
        networking.hostName = "cfserve";

        deployment.buildOnTarget = true;
        deployment = {
          # targetHost = "cfserve.ling-lizard.ts.net";
          targetHost = "192.168.2.119";
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

        imports = [
          # ./overlays/qemu.nix
          ./overlays/desktop.nix
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
        boot.isContainer = true;
        # fileSystems."/" = {
        #   device = "/dev/disk/by-uuid/03c45a7e-9db9-467a-8191-863839ba5e0a";
        #   fsType = "ext4";
        # };

        # fileSystems."/boot" = {
        #   device = "/dev/disk/by-uuid/A8B6-B5CE";
        #   fsType = "vfat";
        # };
      };
    };
  };
}
