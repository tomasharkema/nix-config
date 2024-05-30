{ config, pkgs, lib, ... }:
with lib;
let cfg = config.apps.remote-builders;
in {

  options.apps.remote-builders = { enable = mkEnableOption "remote-builders"; };

  config = mkIf cfg.enable {

    nix.buildMachines = [
      {
        hostName = "builder@blue-fire";
        systems = [ "aarch64-linux" "x86_64-linux" ];
        maxJobs = 4;
        supportedFeatures = [ "kvm" "benchmark" "big-parallel" ];
        speedFactor = 70;
        protocol = "ssh-ng";
      }
      {
        hostName = "builder@wodan";
        systems = [ "aarch64-linux" "x86_64-linux" ];
        maxJobs = 4;
        supportedFeatures = [ "kvm" "benchmark" "big-parallel" ];
        speedFactor = 100;
        protocol = "ssh-ng";
      }
    ];
  };
}
