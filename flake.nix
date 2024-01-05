{
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-23.11";
    unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    nix-netboot-serve = {
      url = "github:DeterminateSystems/nix-netboot-serve";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-wsl = {
      url = "github:nix-community/NixOS-WSL";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-23.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:nixos/nixos-hardware";

    cachix-deploy-flake.url = "github:cachix/cachix-deploy-flake";

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    deploy-rs = {
      url = "github:serokell/deploy-rs";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # colmena.url = "github:zhaofengli/colmena";
    # colmena.inputs.nixpkgs.follows = "nixpkgs";

    # anywhere.url = "github:nix-community/nixos-anywhere";

    # flake-utils.url = "github:numtide/flake-utils";

    vscode-server.url = "github:nix-community/nixos-vscode-server";
    nixvim.url = "github:pta2002/nixvim/nixos-23.11";

    agenix = {
      url = "github:ryantm/agenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-software-center = {
      url = "github:snowfallorg/nix-software-center";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-conf-editor = {
      url = "github:snowfallorg/nixos-conf-editor";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-flatpak = {
      url = "github:gmodena/nix-flatpak";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    impermanence = {
      url = "github:nix-community/impermanence";
    };

    attic = {
      url = "github:zhaofengli/attic";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    system-manager = {
      url = "github:numtide/system-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # tailscale-prometheus-sd = { url = "github:madjam002/tailscale-prometheus-sd"; };
    flake-utils.url = "github:numtide/flake-utils";
    gomod2nix = {
      url = "github:nix-community/gomod2nix";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };

    snowfall-lib = {
      url = "github:snowfallorg/lib";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    snowfall-flake = {
      url = "github:snowfallorg/flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    flake-checker = {
      url = "github:DeterminateSystems/flake-checker";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    fh = {
      url = "github:DeterminateSystems/fh";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    bento = {
      url = "github:rapenne-s/bento";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hydra-check = {
      url = "github:nix-community/hydra-check";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  nixConfig = {
    extra-experimental-features = "nix-command flakes";
    distributedBuilds = true;
    builders-use-substitutes = true;
    trusted-users = ["root" "tomas"];

    substituters = [
      "https://tomasharkema.cachix.org/"
      "https://nix-cache.harke.ma/tomas/"
      "https://nix-community.cachix.org/"
      "https://cache.nixos.org/"
    ];

    trusted-public-keys = [
      "tomasharkema.cachix.org-1:LOeGvH7jlA3vZmW9+gHyw0BDd1C8a0xrQSl9WHHTRuA="
      "tomas:/cvjdgRjoTx9xPqCkeMWkf9csRSAmnqLgN3Oqkpx2Tg="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    ];
    binaryCaches = ["https://cache.nixos.org"];

    allowed-uris = [
      "https://api.github.com"
      "https://git.sr.ht/~rycee/nmd/archive"
      "https://github.com/zhaofengli/nix-base32.git"
      "https://github.com/tomasharkema.keys"
      "https://api.flakehub.com/f/pinned"
      "https://github.com/NixOS/"
      "https://github.com/nixos/"
      "https://github.com/hercules-ci/"
      "https://github.com/numtide/"
      "https://github.com/cachix/"
      "https://github.com/nix-community/"
      "https://github.com/tomasharkema/"
      "git://github.com/tomasharkema"
    ];

    allow-import-from-derivation = true;
    keep-outputs = true;
    keep-derivations = true;
  };

  outputs = inputs: let
    lib = inputs.snowfall-lib.mkLib {
      inherit inputs;
      src = ./.;

      snowfall = {
        meta = {
          name = "dotfiles";
          title = "dotfiles";
        };

        namespace = "custom";
      };
    };
  in
    lib.mkFlake {
      inherit inputs;

      src = ./.;

      channels-config = {
        allowUnfree = true;
        nvidia.acceptLicense = true;
      };

      alias = {
        shells = {
          default = "devshell";
        };
      };

      snowfall = {
        meta = {
          name = "dotfiles";
          title = "dotfiles";
        };

        namespace = "custom";
      };

      overlays = with inputs; [
        snowfall-flake.overlays."package/flake"
      ];

      systems.modules.nixos = with inputs; [
        impermanence.nixosModule
        disko.nixosModules.default

        lanzaboote.nixosModules.lanzaboote

        # home-manager.nixosModules.home-manager
        agenix.nixosModules.default
        nixos-generators.nixosModules.all-formats
        {
          system.stateVersion = "23.11";
        }
      ];

      # homes.modules = with inputs; [
      #   # agenix.homeManagerModules.default
      # ];

      deploy = lib.mkDeploy {
        inherit (inputs) self;

        overrides = {
          sshUser = "root";
          wodan-wsl = {
            sshUser = "root";
            hostname = "192.168.1.42";
          };
        };
      };

      checks = {
        # nixpkgs-lint =
        # inputs.nixpkgs.legacyPackages.${builtins.currentSystem}.nixpkgs-lint ./.;
      };

      # checks =
      #   builtins.mapAttrs
      #   (system: deploy-lib:
      #     deploy-lib.deployChecks inputs.self.deploy)
      #   inputs.deploy-rs.lib;

      hydraJobs = let
        packages =
          lib.filterAttrs (system: v: (system == "x86_64-linux" || system == "aarch64-linux"))
          inputs.self.packages;
        devShells =
          lib.filterAttrs (system: v: (system == "x86_64-linux" || system == "aarch64-linux"))
          inputs.self.devShells;
        hosts =
          builtins.mapAttrs (n: v: v.config.system.build.toplevel)
          inputs.self.nixosConfigurations;
      in
        {
          inherit packages;
          #inherit (inputs.self) images;
          #inherit (inputs.self) checks;
          inherit devShells;
          # inherit hosts;
        }
        // {
          # packages = {
          #   nixos-hosts = channels.nixpkgs.nixos-hosts.override {
          #     hosts = inputs.self.nixosConfigurations;
          #   };
          # };
        };

      images = with inputs; {
        baaa-express = self.nixosConfigurations.baaa-express.config.system.build.sdImage;
        pegasus = self.nixosConfigurations.pegasus.config.system.build.sdImage;

        arthuriso = self.nixosConfigurations.arthur.config.formats.install-iso;

        "blue-fire" = self.nixosConfigurations."blue-fire".config.formats.install-iso;
        "blue-fire-slim" = self.nixosConfigurations."blue-fire-slim".config.formats.install-iso;

        #   silver-star-ferdorie = self.nixosConfigurations.silver-star-ferdorie.config.formats.qcow;

        #   hyperv-installiso =
        #     self.nixosConfigurations.hyperv-nixos.config.formats.qcow;
      };

      # formatter = inputs.nixpkgs.alejandra;
      outputs-builder = channels: {
        formatter = channels.nixpkgs.alejandra;

        # checks = {
        #   fmt-check = channels.nixpkgs.stdenvNoCC.mkDerivation {
        #     name = "fmt-check";
        #     src = ./.;
        #     doCheck = true;
        #     nativeBuildInputs = with channels.nixpkgs; [alejandra shellcheck shfmt];
        #     checkPhase = ''
        #       shfmt -d -s -i 2 -ci .
        #       alejandra -c .
        #       shellcheck -x .
        #     '';
        #   };
        # };
      };
    };
}
