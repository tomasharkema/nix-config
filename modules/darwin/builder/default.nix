{
  lib,
  inputs,
  ...
}:
with inputs; let
  system = "aarch64-darwin";
  pkgs = nixpkgs.legacyPackages."${system}";
  linuxSystem = builtins.replaceStrings ["darwin"] ["linux"] system;
  darwin-builder = nixpkgs.lib.nixosSystem {
    system = linuxSystem;
    modules = [
      "${nixpkgs}/nixos/modules/profiles/macos-builder.nix"
      {
        # imports = [ ../../apps/tailscale ];
        # boot.binfmt.emulatedSystems = ["x86_64-linux"];
        virtualisation = {
          host.pkgs = pkgs;
          useNixStoreImage = true;
          writableStore = true;
          cores = 4;

          darwin-builder = {
            workingDirectory = "/var/lib/darwin-builder";
            # diskSize = 30000;
            # memorySize = 4096;
          };
        };

        networking.useDHCP = true;
        environment.systemPackages = with pkgs; [wget curl cacert];
      }
    ];
  };
in {
  config = lib.mkIf false {
    nix.distributedBuilds = true;

    nix.buildMachines = [
      {
        hostName = "builder@linux-builder";
        system = linuxSystem;
        maxJobs = 4;
        supportedFeatures = ["kvm" "benchmark" "big-parallel"];
        sshKey = "/var/lib/darwin-builder/keys/builder_ed25519";
        speedFactor = 30;
      }
      # {
      #   hostName = "builder@linux-builder";
      #   system = "x86_64-linux";
      #   maxJobs = 4;
      #   supportedFeatures = ["kvm" "benchmark" "big-parallel"];
      #   sshKey = "/var/lib/darwin-builder/keys/builder_ed25519";
      #   speedFactor = 30;
      # }
    ];

    launchd.daemons.darwin-builder = {
      command = "${darwin-builder.config.system.build.macos-builder-installer}/bin/create-builder";
      serviceConfig = {
        KeepAlive = true;
        RunAtLoad = true;
        StandardOutPath = "/var/log/darwin-builder.log";
        StandardErrorPath = "/var/log/darwin-builder.log";
      };
    };
  };
}
