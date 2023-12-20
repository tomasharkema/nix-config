{ nix-darwin
, nix-index-database
, agenix
, home-manager
, nixpkgs
, inputs
, ...
}@attrs:
let
  builder = import ../machines/builder (attrs);

  settings =
    ({ pkgs
     , inputs
     , nixpkgs
     , ...
     }: {

      #eu.nixbuild.net x86_64-linux - 100 1 big-parallel,benchmark
      #eu.nixbuild.net aarch64-linux - 100 1 big-parallel,benchmark
      #eu.nixbuild.net i686-linux - 100 1 big-parallel,benchmark

      #enzian x86_64-linux - 100 1 big-parallel,benchmark,kvm
      #enzian aarch64-linux - 100 1 big-parallel,benchmark,kvm

      #arthur x86_64-linux - 100 1 big-parallel,benchmark,kvm
      #arthur aarch64-linux - 100 1 big-parallel,benchmark,kvm

      #silver-starferdorie x86_64-linux - 100 1 big-parallel,benchmark,kvm
      #silver-starferdorie aarch64-linux - 100 1 big-parallel,benchmark,kvm

      # blue-fire x86_64-linux - 100 1 big-parallel,benchmark,kvm
      # blue-fire aarch64-linux - 100 1 big-parallel,benchmark,kvm

      #silver-star x86_64-linux - 100 1 big-parallel,benchmark,kvm
      #silver-star aarch64-linux - 100 1 big-parallel,benchmark,kvm

      nix.buildMachines = [
        {
          hostName = "blue-fire";
          system = "x86_64-linux";
          maxJobs = 4;
          supportedFeatures = [ "kvm" "benchmark" "big-parallel" ];
          speedFactor = 7;
        }
        {
          hostName = "blue-fire";
          system = "i686-linux";
          maxJobs = 4;
          supportedFeatures = [ "kvm" "benchmark" "big-parallel" ];
          speedFactor = 7;
        }
        {
          hostName = "blue-fire";
          system = "aarch64-linux";
          maxJobs = 4;
          supportedFeatures = [ "kvm" "benchmark" "big-parallel" ];
          speedFactor = 5;
        }
        {
          hostName = "enzian";
          system = "x86_64-linux";
          maxJobs = 4;
          supportedFeatures = [ "kvm" "benchmark" "big-parallel" ];
          speedFactor = 10;
        }
        {
          hostName = "enzian";
          system = "i686-linux";
          maxJobs = 4;
          supportedFeatures = [ "kvm" "benchmark" "big-parallel" ];
          speedFactor = 10;
        }
        {
          hostName = "enzian";
          system = "aarch64-linux";
          maxJobs = 4;
          supportedFeatures = [ "kvm" "benchmark" "big-parallel" ];
          speedFactor = 5;
        }
      ];

      nix.extraOptions = ''
        auto-optimise-store = true
        builders-use-substitutes = true
      '';
      environment.systemPackages = with pkgs; [
        # kitty
        terminal-notifier
      ];


      # services.zerotierone.enable = true;
      # services.zerotierone.joinNetworks = [ "***REMOVED***" ];

      nixpkgs.config.allowUnfree = true;

      services.nix-daemon.enable = true;

      security.pam.enableSudoTouchIdAuth = true;

      users.users.tomas = {
        # isNormalUser = true;
        description = "tomas";
      };
      nix.distributedBuilds = true;

      nix.settings = {
        extra-experimental-features = "nix-command flakes";
        # distributedBuilds = true;
        builders-use-substitutes = true;
        trusted-users = [ "root" "tomas" ];
        extra-substituters = [
          "https://nix-cache.harke.ma/tomas"
          "https://cache.nixos.org/"
        ];
        extra-binary-caches = [
          "https://nix-cache.harke.ma/tomas"
          "https://cache.nixos.org/"
        ];
        trusted-public-keys = [
          "nix-cache.harke.ma:2UhS18Tt0delyOEULLKLQ36uNX3/hpX4sH684B+cG3c="
          "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
        ];
        access-tokens = [ "github.com=***REMOVED***" ];
      };
    });
in
{
  # builder = nix-darwin.lib.darwinSystem {
  #   system = "aarch64-darwin";
  #   specialArgs = {
  #     inherit inputs;
  #   };
  #   modules = [ builder ];
  # };

  "euro-mir" = nix-darwin.lib.darwinSystem
    {
      # system = "aarch64-darwin";
      # specialArgs = {
      #   inherit inputs;
      # };

      modules = [
        ({ pkgs, ... }: {
          nixpkgs.hostPlatform = "aarch64-darwin";
          nixpkgs.config.allowUnfree = true;
          services.nix-daemon.enable = true;
          nix.package = pkgs.nix;
          programs.zsh.enable = true;

        })
        # builder
        nix-index-database.darwinModules.nix-index
        agenix.darwinModules.default
        ../secrets
        # ../apps/iterm
        settings
        home-manager.darwinModules.home-manager
        # self.homeConfigurations."tomas@euro-mir".config
        # self.homeConfigurations."tomas@euro-mir"
        # {
        #   imports = [ self.homeConfigurations."tomas@euro-mir".config ];
        # }
        # self.homeConfigurations."tomas@euro-mir"
        ({


          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = {
            # inherit (attrs) inputs;
            inherit inputs;
          };
          home-manager.users.tomas.imports = [
            agenix.homeManagerModules.default
            ../home.nix
            ({ lib, ... }: {
              # programs.home-manager.enable = true;
              home.username = lib.mkDefault "tomas";
              home.homeDirectory = lib.mkForce "/Users/tomas";
            })
          ];
          # home-manager.backupFileExtension = "bak";
          # home.username = lib.mkDefault "tomas";

        })
        ({ pkgs, lib, ... }:
          let
            maclaunch = pkgs.fetchFromGitHub {
              owner = "hazcod";
              repo = "maclaunch";
              rev = "0a4962623dffa84050b5b778edb69f8603fa6c1a";
              hash = "sha256-CA0bT1auUkDdboQeb7FDl2HM2AMoocrU2/hmBbNYK8A=";
            };
          in
          {
            environment.systemPackages = [
              (pkgs.writeShellScriptBin "maclaunch" ''
                ${lib.attrsets.getBin maclaunch}/bin/maclaunch
              '')
            ];
          }
        )
      ];
    };
}
