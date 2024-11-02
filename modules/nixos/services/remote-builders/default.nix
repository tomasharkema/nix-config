{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.services.remote-builders;

  user = "builder";
in {
  options.services.remote-builders = {
    server.enable = lib.mkEnableOption "remote-builders server";
    client.enable = lib.mkEnableOption "remote-builders client";
  };

  config = {
    age.secrets."builder-key" = lib.mkIf cfg.client.enable {
      rekeyFile = ./builder.key.age;
      generator.script = "ssh-ed25519";
    };

    users = lib.mkIf cfg.server.enable {
      users."${user}" = {
        isNormalUser = true;
        createHome = false;
        group = "${user}";
        # extraGroups = ["rslsync"];
        uid = 1098;
        openssh.authorizedKeys.keyFiles = [
          pkgs.custom.authorized-keys

          ./builder.key.pub
        ];
      };
      groups."${user}" = {};
    };

    nix = {
      settings.trusted-users = lib.mkIf cfg.server.enable ["${user}"];

      distributedBuilds = cfg.client.enable;
      extraOptions = ''
        builders-use-substitutes = true
      '';

      buildMachines = lib.mkIf cfg.client.enable [
        {
          sshUser = "builder";
          sshKey = config.age.secrets."builder-key".path;
          hostName = "blue-fire";
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
          sshUser = "builder";
          sshKey = config.age.secrets."builder-key".path;
          hostName = "enceladus";
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
          sshUser = "builder";
          sshKey = config.age.secrets."builder-key".path;
          hostName = "wodan";
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
