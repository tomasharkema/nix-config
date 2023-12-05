{

  inputs =
    { # Pin our primary nixpkgs repository. This is the main nixpkgs repository
      # we'll use for our configurations. Be very careful changing this because
      # it'll impact your entire system.
      nixpkgs.url = "github:nixos/nixpkgs/nixos-23.11";

      # We use the unstable nixpkgs repo for some packages.
      nixpkgs-unstable.url = "github:nixos/nixpkgs/nixpkgs-unstable";

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

  outputs = { self, nixpkgs, home-manager, darwin, ... }@inputs:
    let
      overlays = [ ];
      mkSystem = import ./lib/mksystem.nix { inherit nixpkgs inputs overlays; };
    in {

      nixosConfigurations.vm-aarch64 = mkSystem "vm-aarch64" {
        system = "aarch64-linux";
        user = "tomas";
      };

      nixosConfigurations.vm-aarch64-prl = mkSystem "vm-aarch64-prl" rec {
        system = "aarch64-linux";
        user = "tomas";
      };

      nixosConfigurations.vm-aarch64-utm = mkSystem "vm-aarch64-utm" rec {
        system = "aarch64-linux";
        user = "tomas";
      };

      nixosConfigurations.vm-intel = mkSystem "vm-intel" rec {
        system = "x86_64-linux";
        user = "tomas";
      };

      nixosConfigurations.wsl = mkSystem "wsl" {
        system = "x86_64-linux";
        user = "tomas";
        wsl = true;
      };

      darwinConfigurations.macbook-pro-m1 = mkSystem "macbook-pro-m1" {
        system = "aarch64-darwin";
        user = "tomas";
        darwin = true;
      };

      darwinConfigurations.vm-aarch64-utm = mkSystem "vm-aarch64-utm" rec {
        system = "aarch64-linux";
        user = "tomas";
        darwin = true;
      };

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
          environment.systemPackages = with pkgs; [
            vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
            wget
            tmux
            vim
            wget
            curl
            git
            coreutils
            curl
            wget
            git
            git-lfs

            tailscale
            fortune
            cachix
            niv

            go
            gotools
            gopls
            go-outline
            gocode
            gopkgs
            gocode-gomod
            godef
            golint
            colima
            docker

            neofetch
            tmux
            yq
            bfg-repo-cleaner
            tmux
            nnn
            mtr
            dnsutils
            ldns
            htop
            vscode
          ];

          time.timeZone = "Europe/Amsterdam";
          services.tailscale.enable = true;
          services.tailscale.authKeyFile = ./tailscalekey.conf;
          system.stateVersion = "23.11";
          security.sudo.wheelNeedsPassword = false;
          nixpkgs.config.allowUnfree = true;

          users.users.tomas = {
            isNormalUser = true;
            description = "tomas";
            extraGroups = [ "networkmanager" "wheel" ];
            packages = with pkgs; [ firefox thunderbird ];

            openssh.authorizedKeys.keys = [
              "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILgD7me/mlDG89ZE/tLTJeNhbo3L+pi7eahB2rUneSR4 tomas"
            ];
          };
        };

        utm = { pkgs, modulesPath, ... }: {
          deployment.tags = [ "vm" ];
          nixpkgs.system = "aarch64-linux";
          deployment.buildOnTarget = true;
          deployment = {
            targetHost = "10.211.70.5";
            targetUser = "tomas";
          };
          boot.isContainer = true;
          # imports = [ (modulesPath + "/profiles/qemu-guest.nix") ];

          # boot.initrd.availableKernelModules =
          #   [ "xhci_pci" "virtio_pci" "usbhid" "usb_storage" "sr_mod" ];
          # boot.initrd.kernelModules = [ ];
          # boot.kernelModules = [ ];
          # boot.extraModulePackages = [ ];

          # fileSystems."/" = {
          #   device = "/dev/disk/by-uuid/88fdc8e4-3ab1-4e0f-8412-dd6077548fc4";
          #   fsType = "ext4";
          # };

          # fileSystems."/boot" = {
          #   device = "/dev/disk/by-uuid/749B-E070";
          #   fsType = "vfat";
          # };

          # boot.loader.systemd-boot.enable = true;
          # boot.loader.efi.canTouchEfiVariables = true;
          networking.networkmanager.enable = true;
          # environment.systemPackages = with pkgs;
          #   [

          #   ];

          # # Enable the X11 windowing system.
          # services.xserver.enable = true;

          # # Enable the GNOME Desktop Environment.
          # services.xserver.displayManager.gdm.enable = true;
          # services.xserver.desktopManager.gnome.enable = true;

          # # Configure keymap in X11
          # services.xserver = {
          #   layout = "us";
          #   xkbVariant = "";
          # };

        };

        enceladus = { pkgs, ... }: {
          deployment.tags = [ "bare" ];
          deployment.buildOnTarget = true;
          deployment = {
            targetHost = "enceladus";
            targetUser = "root";
          };
          boot.isContainer = true;

          # environment.systemPackages = with pkgs; [ ];
        };
      };
    };
}
