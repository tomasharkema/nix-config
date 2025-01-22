{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.services.tailscale.tsnsrv;
in {
  options.services.tailscale.tsnsrv = {
    enable = lib.mkEnableOption "tsnsrv";

    package = lib.mkPackageOption pkgs.custom "tsnsrv" {};
    stateDir = lib.mkOption {
      default = "/var/lib/tsnsrv";
      type = lib.types.str;
    };

    vhosts = lib.mkOption {
      default = {};
      type = lib.types.attrsOf (lib.types.submodule {
        options = {
          port = lib.mkOption {
            type = lib.types.int;
          };
        };
      });
    };
  };

  config = {
    systemd.services =
      lib.mapAttrs' (name: opt: {
        name = "tsnsrv-${name}";
        value = {
          environment = {
            TS_STATE_DIR = cfg.stateDir;
          };
          script = "${cfg.package}/bin/tsnsrv -name \"${name}\" \"http://127.0.0.1:${builtins.toString opt.port}\"";
          wantedBy = ["multi-user.target"];
        };
      })
      cfg.vhosts;
  };
}
