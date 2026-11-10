{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.services.rocrail;
in {
  options.services.rocrail = {
    enable = lib.mkEnableOption "rocrail";

    package = lib.mkPackageOption pkgs "rocrail" {};
  };

  config = lib.mkIf cfg.enable {
    systemd.services.rocrail = let
      pkg = cfg.package;
    in {
      script = "${pkg}/bin/rocrail -l ${pkg}/bin -w /var/lib/rocrail";
      description = "Rocrail";
      after = ["network.target"];
      wants = ["network-online.target"];
      wantedBy = ["multi-user.target"];

      serviceConfig = {
        WorkingDirectory = "/var/lib/rocrail";
      };
    };
  };
}
