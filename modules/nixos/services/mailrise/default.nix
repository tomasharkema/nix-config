{ config, pkgs, lib, ... }:
with lib;
let
  cfg = config.services.mailrise;
  settingsFormat = pkgs.formats.yaml { };
in {
  options.services.mailrise = {
    enable = mkEnableOption "mailrise";
    # package = mkPackageOption pkgs "goss" { };
    settings = mkOption {
      type = lib.types.submodule { freeformType = settingsFormat.type; };
      default = { };
    };
  };

  config = {

    systemd.services.mailrise = let settingsFile = cfg.settings;
    in {
      description = "mailrise";
      enable = true;

      script = "${pkgs.custom.mailrise}/bin/mailrise ${settingsFile}";
      wantedBy = [ "multi-user.target" ];
    };

  };
}
