{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.apps.attic-server;
in {
  options.apps.attic-server = {
    enable = mkEnableOption "attic-server";
  };

  config = mkIf cfg.enable {
    # services.atticd = {
    #   enable = true;
    #   credentialsFile = config.age.secrets."peerix-private".path;
    # };
  };
}
