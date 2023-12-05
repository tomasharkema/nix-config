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

        imports = [ ./packages.nix ];

        # environment.systemPackages = with pkgs; [
        #   vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
        #   wget
        #   tmux
        #   vim
        #   wget
        #   curl
        #   git
        #   coreutils
        #   curl
        #   wget
        #   git
        #   git-lfs

        #   tailscale
        #   fortune
        #   cachix
        #   niv

        #   go
        #   gotools
        #   gopls
        #   go-outline
        #   gocode
        #   gopkgs
        #   gocode-gomod
        #   godef
        #   golint
        #   colima
        #   docker

        #   neofetch
        #   tmux
        #   yq
        #   bfg-repo-cleaner
        #   tmux
        #   nnn
        #   mtr
        #   dnsutils
        #   ldns
        #   htop
        #   vscode

        #   git

        #   btop

        #   firefox
        # ];

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
          # packages = with pkgs; [ firefox ];

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
        services.netdata = {
          enable = true;
          package = pkgs.netdata.override { withCloud = true; };
        };
        # environment.var."lib/netdata/cloud.d/token" = {
        #   mode = "0600";
        #   source = ./cloudtoken.conf;
        # };
      };

      utm-nixos = { pkgs, modulesPath, ... }: {
        networking.hostName = "utm-nixos";
        deployment.tags = [ "vm" ];
        nixpkgs.system = "aarch64-linux";
        deployment.buildOnTarget = true;
        deployment = {
          targetHost = "10.211.70.5";
          targetUser = "root";
        };
        boot.isContainer = true;

        networking.networkmanager.enable = true;
        services.xserver.enable = true;
        services.xserver.displayManager.gdm.enable = true;
        services.xserver.desktopManager.gnome.enable = true;
        networking.firewall.enable = false;
      };

      utm-ferdorie = { pkgs, modulesPath, ... }: {
        networking.hostName = "utm-ferdorie";
        deployment.tags = [ "vm" ];
        nixpkgs.system = "aarch64-linux";
        deployment.buildOnTarget = true;
        deployment = {
          targetHost = "100.119.250.94";
          targetUser = "root";
        };
        boot.isContainer = true;

        networking.networkmanager.enable = true;
        services.xserver.enable = true;
        services.xserver.displayManager.gdm.enable = true;
        services.xserver.desktopManager.gnome.enable = true;
        networking.firewall.enable = false;
      };

      enceladus = { pkgs, ... }: {
        networking.hostName = "enceladus";
        deployment.tags = [ "bare" ];
        deployment.buildOnTarget = true;
        deployment = {
          targetHost = "enceladus";
          targetUser = "root";
        };
        boot.isContainer = true;
      };

      hyperv = { pkgs, ... }: {
        networking.hostName = "hyperv-nixos";
        deployment.tags = [ "vm" ];

        deployment.buildOnTarget = true;
        deployment = {
          targetHost = "100.64.161.30";
          targetUser = "root";
        };

        virtualisation.hypervGuest.enable = true;

        boot.isContainer = true;
        networking.networkmanager.enable = true;
        services.xserver.enable = true;
        services.xserver.displayManager.gdm.enable = true;
        services.xserver.desktopManager.gnome.enable = true;
        networking.firewall.enable = false;
      };

      cfserve = { pkgs, ... }: {
        deployment.tags = [ "bare" ];
        networking.hostName = "cfserve";

        deployment.buildOnTarget = true;
        deployment = {
          targetHost = "cfserve.ling-lizard.ts.net";
          targetUser = "root";
        };

        boot.isContainer = true;
        networking.networkmanager.enable = true;
        services.xserver.enable = true;
        services.xserver.displayManager.gdm.enable = true;
        services.xserver.desktopManager.gnome.enable = true;
        networking.firewall.enable = false;
      };
    };
  };
}
