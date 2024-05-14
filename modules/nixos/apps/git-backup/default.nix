# https://github.com/bocytko/git-backup
{ pkgs, lib, config, ... }:
with pkgs.python3Packages;
let
  cfg = config.gui.gnome;

  # git-backup = pkgs.fetchFromGitHub {
  #   owner = "bocytko";
  #   repo = "git-backup";
  #   rev = "d317560d74666e3e5630b1300017a9df51d0584c";
  #   hash = "sha256-+FYSoR+Q66gVIqUgJJnpitx9kMLmjBoLdTSQqRlbW64=";
  # };

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
    runtimeInputs = with pkgs; [ git hostname dconf mktemp openssh hostname ];
    text = ''
      set -eux

      export GIT_SSH_COMMAND="git -o IdentitiesOnly=yes"

      DIRECTORY="$(mktemp -d)"
      mkdir -p "$DIRECTORY" || true

      function cleanup {
        echo "Removing $DIRECTORY"
        rm -rf "$DIRECTORY"
      }

      trap cleanup EXIT

      git clone --depth=1 git@github.com:tomasharkema/dconf-backup.git "$DIRECTORY" || {
        printf "Error: git clone of configuration repo failed\n"
        exit 1
      }

      USER_DIRECTORY="$DIRECTORY/$(hostname)"
      mkdir -p "$USER_DIRECTORY" || true

      dconf dump / > "$USER_DIRECTORY/backup.conf"

      cd "$DIRECTORY"

      if ! git diff --quiet HEAD || git status --short; then
        git add --all
        git commit -m "updating dotfiles on $(date -u)"
        git push origin main
      fi

    '';
  };
  key-path = config.age.secrets."healthcheck".path;
in {
  config = lib.mkIf (cfg.enable && false) {
    # programs.ssh.knownHostsFiles = let
    #   known-keys-command = pkgs.runCommand "known-keys" {} ''
    #     ${pkgs.openssh}/bin/ssh-keyscan github.com | tee $out
    #   '';
    # in [
    #   #
    #   known-keys-command
    # ];

    systemd = {
      # services.healthcheck-key = {
      #   description = "healthcheck";
      #   serviceConfig = {
      #     Type = "oneshot";
      #     ExecStart = pkgs.writeShellScript "healthcheck-key-script" ''
      #       echo "got file!"
      #     '';
      #   };
      # };
      # paths.healthcheck-key = {
      #   description = "healthcheck";
      #   wantedBy = []; # ["multi-user.target"];
      #   # This file must be copied last
      #   pathConfig.PathExists = ["${key-path}"];
      # };

      services."dconf-sync" = {
        description = "dconf-sync-service";
        # ${lib.getExe pkgs.curl} "$PINGURL/start?create=1" -m 10 || true
        # result=$(${lib.getExe sync-script} 2>&1)
        # echo "$result"
        # ${lib.getExe pkgs.curl} -m 10 --retry 5 --data-raw "$result" "$PINGURL/$?" || true

        serviceConfig = {
          Type = "oneshot";
          User = "tomas";

          RemainAfterExit = true;
        };
        script = ''
          export HC_PING_KEY="$(cat ${key-path})"
          HNAME="$(${lib.getExe pkgs.hostname})"
          SNAME="dconf-$HNAME"

          ${lib.getExe pkgs.runitor} -slug "$SNAME" -every 1h -- ${
            lib.getExe sync-script
          }
        '';
        # after = ["healthcheck-key.path"];
        # wants = ["healthcheck-key.path"];
      };

      timers."dconf-sync" = {
        description = "dconf-sync";
        wantedBy = [ "timers.target" ];
        timerConfig = {
          OnUnitActiveSec = "5m";
          Unit = "dconf-sync.service";

          OnCalendar = "*-*-* *:00,10,20,30,40,50:00";
          Persistent = true;
        };
      };
    };
  };
}
