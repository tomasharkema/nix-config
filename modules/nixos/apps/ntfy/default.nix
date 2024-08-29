{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.apps.ntfy;
  subscribeCfg = cfg.subscribe;
in {
  options.apps.ntfy = {
    subscribe = {
      enable = (mkEnableOption "enable ntfy subscribe") // {default = true;};

      subscriptions = mkOption {
        type = types.listOf types.str;
        default = [
          "tomasharkema-nixos"
          "$NIXOS_TOPIC_NAME"
          "$PLEX_TOPIC_NAME"
        ];
      };

      environmentFile = mkOption {
        type = types.nullOr types.path;
        default = config.age.secrets."notify-sub".path;
      };
    };
  };

  config = let
    configFileUnsubstituted = pkgs.writers.writeYAML "ntfy-client.yml" {
      subscribe =
        builtins.map (v: {
          topic = v;
          # ${pkgs.libnotify}/bin/
          command = "notify-send \"NTFY-${v}\" \"$\{DOLLAR\}m\"";
        })
        subscribeCfg.subscriptions;
    };
  in
    mkIf subscribeCfg.enable {
      age.secrets."notify-sub" = {
        rekeyFile = ./notify-sub.age;
        mode = "666";
      };

      systemd.user.services."ntfy-client" = {
        path = with pkgs; [ntfy-sh libnotify envsubst];
        serviceConfig = {
          PrivateTmp = true;
          EnvironmentFile = mkIf (subscribeCfg.environmentFile != null) subscribeCfg.environmentFile;
          # EnvironmentFile = ["$CREDENTIALS_DIRECTORY/envsec"];
          # LoadCredential =
          #   mkIf (subscribeCfg.environmentFile != null)
          #   [
          #     "envsec:${subscribeCfg.environmentFile}"
          #   ];
        };

        preStart = ''
          [ -f "/tmp/ntfy-client.yml" ] && rm -f "/tmp/ntfy-client.yml"
          old_umask=$(umask)
          umask 0177

          export DOLLAR='$'
          envsubst \
            -o "/tmp/ntfy-client.yml" \
            -i "${configFileUnsubstituted}"
          umask $old_umask
        '';

        # ${pkgs.ntfy-sh}/bin/
        script = ''
          ntfy subscribe --config="/tmp/ntfy-client.yml" --from-config
        '';

        description = "ntfy client";
        after = ["network.target"];
        reloadTriggers = ["on-failure"];
        wantedBy = ["default.target"];
      };
    };
}
