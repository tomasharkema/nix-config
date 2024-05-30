{ config, pkgs, lib, ... }:
with lib;
let cfg = config.services.builder-service;
in {
  options.services.builder-service = {
    enable = mkEnableOption "builder-service";
  };

  config = mkIf cfg.enable {
    age.secrets."hercules-cli.key" = {
      file = ../../secrets/hercules-cli.key.age;
      # mode = "644";
      # path = "/var/lib/hercules-ci-agent/secrets/cluster-join-token.key";
    };

    services.hercules-ci-agent = {
      enable = true;

      settings.clusterJoinTokenPath =
        config.age.secrets."hercules-cli.key".path;
    };
  };
}
