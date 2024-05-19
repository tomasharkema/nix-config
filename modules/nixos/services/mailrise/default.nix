{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.services.mailrise;
  settingsFormat = pkgs.formats.yaml { };
  configFile = settingsFormat.generate "goss.yaml" cfg.settings;
in {
  options.services.mailrise = {
    enable = mkEnableOption "mailrise";
    # package = mkPackageOption pkgs "goss" { };
    settings = mkOption {
      type = lib.types.submodule { freeformType = settingsFormat.type; };
      default = { };
    };
  };

  config = mkIf cfg.enable {

    systemd.services.mailrise = {
      description = "mailrise";
      enable = true;

      script = "${pkgs.custom.mailrise}/bin/mailrise ${configFile}";
      wantedBy = [ "multi-user.target" ];
    };

  };
}
