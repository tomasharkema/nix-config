{ nix-darwin
, nix-index-database
, agenix
, home-manager
, lib
, nixpkgs
, inputs
, ...
}@attrs:
let
  builder = import ../machines/builder (attrs);

  settings =
    ({ pkgs
     , inputs
     , ...
     }: {

      #eu.nixbuild.net x86_64-linux - 100 1 big-parallel,benchmark
      #eu.nixbuild.net aarch64-linux - 100 1 big-parallel,benchmark
      #eu.nixbuild.net i686-linux - 100 1 big-parallel,benchmark

      #enceladus x86_64-linux - 100 1 big-parallel,benchmark,kvm
      #enceladus aarch64-linux - 100 1 big-parallel,benchmark,kvm

      #cfserve x86_64-linux - 100 1 big-parallel,benchmark,kvm
      #cfserve aarch64-linux - 100 1 big-parallel,benchmark,kvm

      #unraidferdorie x86_64-linux - 100 1 big-parallel,benchmark,kvm
      #unraidferdorie aarch64-linux - 100 1 big-parallel,benchmark,kvm

      # supermicro x86_64-linux - 100 1 big-parallel,benchmark,kvm
      # supermicro aarch64-linux - 100 1 big-parallel,benchmark,kvm

      #tower x86_64-linux - 100 1 big-parallel,benchmark,kvm
      #tower aarch64-linux - 100 1 big-parallel,benchmark,kvm

      nix.buildMachines = [
        # {
        #   hostName = "supermicro";
        #   system = "x86_64-linux";
        #   maxJobs = 4;
        #   supportedFeatures = [ "kvm" "benchmark" "big-parallel" ];
        #   speedFactor = 7;
        # }
        # {
        #   hostName = "supermicro";
        #   system = "aarch64-linux";
        #   maxJobs = 4;
        #   supportedFeatures = [ "kvm" "benchmark" "big-parallel" ];
        #   speedFactor = 5;
        # }

        # {
        #   hostName = "enceladus";
        #   system = "x86_64-linux";
        #   maxJobs = 4;
        #   supportedFeatures = [ "kvm" "benchmark" "big-parallel" ];
        #   speedFactor = 10;
        # }
        # {
        #   hostName = "enceladus";
        #   system = "aarch64-linux";
        #   maxJobs = 4;
        #   supportedFeatures = [ "kvm" "benchmark" "big-parallel" ];
        #   speedFactor = 5;
        # }
      ];

      nix.extraOptions = ''
        auto-optimise-store = true
        builders-use-substitutes = true
      '';
      environment.systemPackages = with pkgs; [
        kitty
        terminal-notifier
      ];

      # services.zerotierone.enable = true;
      # services.zerotierone.joinNetworks = [ "af78bf9436bca877" ];

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
          "https://nix-cache.harke.ma/"
          "https://cache.nixos.org/"
        ];
        extra-binary-caches = [
          "https://nix-cache.harke.ma/"
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
  builder = nix-darwin.lib.darwinSystem {
    system = "aarch64-darwin";
    specialArgs = {
      inherit inputs;
    };
    modules = [ builder ];
  };

  "MacBook-Pro-van-Tomas" = nix-darwin.lib.darwinSystem
    {
      system = "aarch64-darwin";
      specialArgs = {
        inherit inputs;
      };

      modules = [
        builder
        # statix.overlays.default
        nix-index-database.darwinModules.nix-index
        agenix.darwinModules.default
        ../secrets
        # ../apps/iterm
        settings
        home-manager.darwinModules.home-manager
        # self.homeConfigurations."tomas@MacBook-Pro-van-Tomas".config
        # self.homeConfigurations."tomas@MacBook-Pro-van-Tomas"
        # {
        #   imports = [ self.homeConfigurations."tomas@MacBook-Pro-van-Tomas".config ];
        # }
        # self.homeConfigurations."tomas@MacBook-Pro-van-Tomas"
        {
          # home-manager.useGlobalPkgs = true;
          # home-manager.useUserPackages = true;
          home-manager.extraSpecialArgs = {
            inherit (attrs) inputs;
          };
          home-manager.users.tomas.imports = [
            agenix.homeManagerModules.default
            ../home.nix
            ({
              home.homeDirectory = lib.mkForce "/Users/tomas";
            })
          ];
          home-manager.backupFileExtension = "bak";
          # home.username = lib.mkDefault "tomas";

        }
      ];
    };
}
