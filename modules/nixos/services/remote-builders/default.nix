{
  config,
  pkgs,
  lib,
  inputs,
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
    age.secrets."builder-key" = {
      rekeyFile = ./builder.key.age;
      generator.script = "ssh-ed25519";
    };

    users = lib.mkIf cfg.server.enable {
      users."${user}" = {
        isNormalUser = true;
        createHome = true;
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

      distributedBuilds = true;
      extraOptions = ''
        builders-use-substitutes = true
      '';

      buildMachines =
        [
          {
            hostName = "raspi5";
            sshKey = config.age.secrets."builder-key".path;
            sshUser = "builder";
            system = "aarch64-linux";
            maxJobs = 4;
            supportedFeatures = [
              "kvm"
              "benchmark"
              "big-parallel"
            ];
            protocol = "ssh-ng";
          }
        ]
        ++ (
          lib.optionals cfg.client.enable [
            {
              sshUser = "builder";
              sshKey = config.age.secrets."builder-key".path;
              hostName = "blue-fire";
              system = "x86_64-linux";
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
              hostName = "silver-star";
              system = "x86_64-linux";
              maxJobs = 8;
              supportedFeatures = [
                "kvm"
                "benchmark"
                "big-parallel"
              ];
              speedFactor = 80;
              protocol = "ssh-ng";
            }
            {
              sshUser = "builder";
              sshKey = config.age.secrets."builder-key".path;
              hostName = "wodan";
              system = "x86_64-linux";
              maxJobs = 4;
              supportedFeatures = [
                "kvm"
                "benchmark"
                "big-parallel"
              ];
              speedFactor = 100;
              protocol = "ssh-ng";
            }
          ]
        );
    };
  };
}
