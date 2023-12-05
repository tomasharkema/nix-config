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

  outputs = { nixpkgs, ... }: {
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

        services.openssh = {
          enable = true;
          # require public key authentication for better security
          settings.PasswordAuthentication = false;
          settings.KbdInteractiveAuthentication = false;
          settings.PermitRootLogin = "yes";
        };
      };

      utm = { pkgs, modulesPath, name, ... }: {
        networking.hostName = name;
        deployment.tags = [ "vm" ];
        nixpkgs.system = "aarch64-linux";
        deployment.buildOnTarget = true;
        deployment = {
          targetHost = "10.211.70.5";
          targetUser = "tomas";
        };
        boot.isContainer = true;
      };

      enceladus = { pkgs, name, ... }: {
        networking.hostName = name;
        deployment.tags = [ "bare" ];
        deployment.buildOnTarget = true;
        deployment = {
          targetHost = "enceladus";
          targetUser = "root";
        };
        boot.isContainer = true;

        # environment.systemPackages = with pkgs; [ ];
      };

      hyperv = { pkgs, name, ... }: {
        networking.hostName = name;
        deployment.tags = [ "vm" ];

        deployment.buildOnTarget = true;
        deployment = {
          targetHost = "192.168.1.73";
          targetUser = "root";
        };

        boot.isContainer = true;
      };
    };
  };
}
