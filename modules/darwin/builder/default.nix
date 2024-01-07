{
  config,
  lib,
  inputs,
  ...
}:
with inputs;
with lib;
with lib.custom; let
  darwin-builder = inputs.self.nixosConfigurations.darwin-builder;

  cfg = config.apps.builder;
in {
  options.apps.builder = {
    enable = mkBoolOpt true "SnowflakeOS GNOME configuration";
  };

  config = mkIf cfg.enable {
    nix = {
      distributedBuilds = true;

      buildMachines = [
        {
          hostName = "builder@linux-builder";
          systems = ["aarch64-linux" "x86_64-linux"];
          maxJobs = 4;
          supportedFeatures = ["kvm" "benchmark" "big-parallel"];
          sshKey = "/var/lib/darwin-builder/keys/builder_ed25519";
          speedFactor = 30;
        }
      ];
    };

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
