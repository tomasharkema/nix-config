# https://github.com/bocytko/git-backup
{
  pkgs,
  lib,
  config,
  ...
}:
with pkgs.python3Packages; let
  cfg = config.gui.gnome;

  git-backup = pkgs.fetchFromGitHub {
    owner = "bocytko";
    repo = "git-backup";
    rev = "d317560d74666e3e5630b1300017a9df51d0584c";
    hash = "sha256-+FYSoR+Q66gVIqUgJJnpitx9kMLmjBoLdTSQqRlbW64=";
  };

  # DIRECTORY="/resilio-sync/shared-documents/dconf/$(${lib.getExe pkgs.hostname})"
  # if [ ! -d "$DIRECTORY" ]; then
  #   mkdir -p $DIRECTORY
  # fi

  # directory = "/tmp/dconf-sync";

  # bakConfig = {
  #   "token" = "6b86190dd45c57c1a1b039a5a54d892e019102f7";
  #   "directory" = directory;
  # };

  # configFile = pkgs.writeText "config.json" (builtins.toJSON bakConfig);

  sync-script = pkgs.writeShellApplication {
    name = "sync-script";
    runtimeInputs = with pkgs; [git hostname dconf mktemp];
    text = ''
      set -eux

      DIRECTORY="$(mktemp -d)"
      mkdir -p "$DIRECTORY" || true

      git clone --depth=1 git@github.com:tomasharkema/dconf-backup.git "$DIRECTORY" || {
        printf "Error: git clone of configuration repo failed\n"
        exit 1
      }

      USER_DIRECTORY="$DIRECTORY/$(hostname)"
      mkdir -p "$USER_DIRECTORY" || true

      dconf dump / > "$USER_DIRECTORY/backup.conf"

      if ! git diff --quiet HEAD || git status --short; then
        git add --all
        git commit -m "updating dotfiles on $(date -u)"
        git push origin main
      fi

    '';
  };
in {
  config = lib.mkIf cfg.enable {
    systemd.services."dconf-sync" = {
      script = ''
        set -eu
        ${lib.getExe sync-script}
      '';
      serviceConfig = {
        Type = "oneshot";
        User = "tomas";
      };
    };

    systemd.timers."dconf-sync" = {
      wantedBy = ["timers.target"];
      timerConfig = {
        OnBootSec = "5m";
        OnUnitActiveSec = "5m";
        Unit = "dconf-sync.service";
      };
    };
  };
}
