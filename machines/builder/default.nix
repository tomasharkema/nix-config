{ self
, nix-darwin
, nixpkgs
, ...
}@inputs:
let

  # inherit (nix-darwin.lib) darwinSystem;
  system = "aarch64-darwin";
  pkgs = nixpkgs.legacyPackages."${system}";
  linuxSystem = builtins.replaceStrings [ "darwin" ] [ "linux" ] system;

  darwin-builder = nixpkgs.lib.nixosSystem {
    system = linuxSystem;
    modules = [
      "${nixpkgs}/nixos/modules/profiles/macos-builder.nix"
      {
        virtualisation = {
          host.pkgs = pkgs;
          darwin-builder.workingDirectory = "/var/lib/darwin-builder";
        };
      }
    ];
  };
in

{
  nix.distributedBuilds = true;

  nix.buildMachines = [{
    hostName = "builder@localhost";
    system = linuxSystem;
    maxJobs = 4;
    supportedFeatures = [ "kvm" "benchmark" "big-parallel" ];
  }];

  launchd.daemons.darwin-builder = {
    command = "${darwin-builder.config.system.build.macos-builder-installer}/bin/create-builder";
    serviceConfig = {
      KeepAlive = true;
      RunAtLoad = true;
      StandardOutPath = "/var/log/darwin-builder.log";
      StandardErrorPath = "/var/log/darwin-builder.log";
    };
  };
}
