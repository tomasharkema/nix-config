{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.services.remote-builders;
in {
  options.services.remote-builders = {
    server.enable = mkEnableOption "remote-builders";
    client.enable = mkEnableOption "remote-builders";
  };

  config = {
    users.users.builder = mkIf cfg.server.enable {
      isSystemUser = true;
      group = "agent";
      # extraGroups = ["rslsync"];
      uid = 1098;
      openssh.authorizedKeys.keyFiles = [pkgs.custom.authorized-keys];
    };

    nix.settings.trusted-users = mkIf cfg.server.enable ["builder"];

    nix.buildMachines = mkIf cfg.client.enable [
      {
        hostName = "builder@blue-fire";
        systems = ["aarch64-linux" "x86_64-linux"];
        maxJobs = 4;
        supportedFeatures = ["kvm" "benchmark" "big-parallel"];
        speedFactor = 70;
        protocol = "ssh-ng";
      }
      {
        hostName = "builder@wodan";
        systems = ["aarch64-linux" "x86_64-linux"];
        maxJobs = 4;
        supportedFeatures = ["kvm" "benchmark" "big-parallel"];
        speedFactor = 100;
        protocol = "ssh-ng";
      }
    ];
  };
}
