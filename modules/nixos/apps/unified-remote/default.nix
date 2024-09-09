# pkgs.custom.unified-remote
{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.apps.unified-remote;

  home = "/var/lib/urserver";

  settingType = with lib.types;
    (oneOf [bool int float str (listOf settingType) (attrsOf settingType)])
    // {
      description = "JSON value";
    };

  settingsFile = pkgs.writeText "settings.json" (builtins.toJSON cfg.settings);

  configTarget = "${home}/.urserver/urserver.config";
in {
  options.apps.unified-remote = {
    enable = lib.mkEnableOption "unified-remote";
    package = lib.mkOption {
      type = lib.types.package;
      default = pkgs.custom.unified-remote;
    };
    pid = lib.mkOption {
      type = lib.types.str;
      default = "/run/urserver.pid";
    };
    settings = lib.mkOption {
      type = lib.types.attrsOf settingType;
      default = {
        "manager" = {
          "enable" = true;
          "login" = true;
          "password" = "admin";
          "path" = "${cfg.package}/opt/urserver/manager";
          "remote" = true;
          "username" = "admin";
          "web" = true;
        };
      };
    };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = [pkgs.custom.unified-remote];

    systemd = {
      tmpfiles.rules = ["d ${home}/.urserver 0777 root root -"];
      services."unified-remote" = {
        wantedBy = ["multi-user.target"];
        # wants = [ "network-online.target" ];
        # after = [ "network-online.target" ];
        description = "unified-remote";
        # environment.SHELL = "/bin/sh";

        path = [cfg.package];

        environment = {HOME = home;};

        preStart = ''
          if [ ! -f "${configTarget}" ]; then
            cp ${settingsFile} ${configTarget}
          fi
        '';

        script = ''
          exec ${cfg.package}/bin/urserver --remotes=${cfg.package}/opt/urserver/remotes --pidfile=${cfg.pid} --daemon
        '';

        serviceConfig = {
          PIDFile = "${cfg.pid}";

          Type = "simple";

          Restart = "always";
          RestartSec = 12;
          # DynamicUser = true;
          # CacheDirectory = "spotifyd";
          # SupplementaryGroups = [ "audio" ];
        };
      };
    };
  };
}
