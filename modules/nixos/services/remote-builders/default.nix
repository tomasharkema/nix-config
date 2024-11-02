{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.services.remote-builders;
in {
  options.services.remote-builders = {
    server.enable = lib.mkEnableOption "remote-builders server";
    client.enable = lib.mkEnableOption "remote-builders client";
  };

  config = {
    users = {
      users.builder = lib.mkIf cfg.server.enable {
        isNormalUser = true;
        createHome = false;
        group = "builder";
        # extraGroups = ["rslsync"];
        uid = 1098;
        openssh.authorizedKeys.keyFiles = [pkgs.custom.authorized-keys];
      };
      groups.builder = {};
    };

    nix = {
      settings.trusted-users = lib.mkIf cfg.server.enable ["builder"];

      distributedBuilds = cfg.client.enable;
      extraOptions = ''
        builders-use-substitutes = true
      '';

      buildMachines = lib.mkIf cfg.client.enable [
        {
          hostName = "builder@blue-fire";
          systems = ["aarch64-linux" "x86_64-linux"];
          maxJobs = 4;
          supportedFeatures = [
            "kvm"
            "benchmark"
            "big-parallel"
          ];
          speedFactor = 70;
          protocol = "ssh-ng";
        }
        {
          hostName = "builder@enceladus";
          systems = ["aarch64-linux" "x86_64-linux"];
          maxJobs = 4;
          supportedFeatures = [
            "kvm"
            "benchmark"
            "big-parallel"
          ];
          speedFactor = 50;
          protocol = "ssh-ng";
        }
        {
          hostName = "builder@wodan";
          systems = ["aarch64-linux" "x86_64-linux"];
          maxJobs = 4;
          supportedFeatures = [
            "kvm"
            "benchmark"
            "big-parallel"
          ];
          speedFactor = 100;
          protocol = "ssh-ng";
        }
      ];
    };
  };
}
