{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.services.builder-service;
in {
  options.services.builder-service = {
    enable = mkEnableOption "builder-service";
  };

  config = mkIf (cfg.enable && false) {
    age.secrets."hercules-cli.key" = {
      rekeyFile = ../../secrets/hercules-cli.key.age;
      # mode = "644";
      # path = "/var/lib/hercules-ci-agent/secrets/cluster-join-token.key";
    };

    services.hercules-ci-agent = {
      enable = true;

      settings = {
        clusterJoinTokenPath = config.age.secrets."hercules-cli.key".path;
        binaryCachesPath =
          pkgs.writeText "binary-caches.json"
          (builtins.toJSON {
            tomas = {
              kind = "NixCache";
              storeURI = "htpps://nix-cache.harke.ma/tomas/";
              publicKeys = ["tomas:hER/5A08v05jH8GnQUZRrh33+HDNbeiJj8z/8JY6ZvI="];
            };
          });
      };
    };
  };
}
