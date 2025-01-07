{
  pkgs,
  config,
  lib,
  ...
}: let
  commonExcludes = [
    # Largest cache dirs
    ".cache"
    "*/cache2" # firefox
    "*/Cache"
    ".config/Slack/logs"
    ".config/Code/CachedData"
    ".container-diff"
    ".npm/_cacache"
    # Work related dirs
    "*/node_modules"
    "*/bower_components"
    "*/_build"
    "*/.tox"
    "*/venv"
    "*/.venv"
    ".local/share/containers"
    "Downloads"
  ];

  sshKey =
    if config.traits.hardware.tpm.enable
    then "/home/tomas/.ssh/id_ecdsa.tpm"
    else "/home/tomas/.ssh/id_ed25519";
in {
  config = lib.mkIf false {
    services.borgbackup = {
      # enable = true;

      jobs.home-tomas = rec {
        user = "tomas";
        group = "tomas";
        paths = "/home/tomas";
        encryption.mode = "none";
        # environment.BORG_RSH = "ssh -i ${sshKey}";
        repo = "ssh://tomas@dione.mastodon-mizar.ts.net/volumes1/tomas/borg";
        compression = "auto,zstd";
        startAt = "hourly";
        persistentTimer = true;
        # extraArgs = [
        # repo
        # "--remote-path=/usr/local/bin/borg"
        # ];
        exclude = commonExcludes;
      };
    };
  };
}
