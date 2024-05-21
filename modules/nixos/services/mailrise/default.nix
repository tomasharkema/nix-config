{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.services.mailrise;
  settingsFormat = pkgs.formats.yaml { };
  configFile = settingsFormat.generate "mailrise.conf" cfg.settings;
  configFileRecreated = "/run/mailrise/mailrise.conf";
in {
  options.services.mailrise = {
    enable = mkEnableOption "mailrise";
    settings = mkOption {
      type = lib.types.submodule { freeformType = settingsFormat.type; };
      default = { };
    };
    secrets = mkOption {
      type = with types; attrsOf (oneOf [ (listOf str) str path ]);
      default = { };
    };
  };

  config = mkIf cfg.enable {

    systemd.services.mailrise = {
      description = "mailrise";
      enable = true;

      preStart = let
        cmds = (lib.attrsets.mapAttrsToList (name: value:
          "${pkgs.replace-secret}/bin/replace-secret ${name} ${value} ${configFileRecreated}")
          cfg.secrets);

        cmdsString = (lib.strings.concatMapStrings (x: x + "\n") cmds);

      in ''
        mkdir -p $(dirname ${configFileRecreated}) || true
        cat ${configFile} > ${configFileRecreated}

        ${cmdsString}
      '';

      restartTriggers = [ configFile configFileRecreated ];

      script = "${pkgs.custom.mailrise}/bin/mailrise ${configFileRecreated}";
      wantedBy = [ "multi-user.target" ];
    };

  };
}
