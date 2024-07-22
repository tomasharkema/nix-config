{
  lib,
  inputs,
  pkgs,
  config,
  ...
}:
with lib;
# with lib.custom;
with pkgs; let
  cfg = config.apps.attic;
in {
  options.apps.attic = with lib.types; {
    enable = mkEnableOption "enable attic conf";

    # user = mkOption {
    #   default = "tomas";
    #   type = str;
    # };

    serverName = mkOption {
      default = "backup";
      type = str;
    };
    storeName = mkOption {
      default = "tomas";
      type = str;
    };
    serverAddress = mkOption {
      # default = "https://nix-cache.harke.ma/";

      default = "http://192.168.0.100:6067/";
      type = str;
    };
  };

  config = mkIf cfg.enable {
    # services.nixos-service = {
    #   enable = true;

    #   serverName = cfg.storeName;
    #   serverUrl = cfg.serverAddress;
    #   secretPath = config.age.secrets.attic-key.path;
    #   mode = "0777";
    # };

    # users.users.tomas.extraGroups = [config.services.nixos-service.group];

    systemd.services.attic-watch-store = {
      wantedBy = ["multi-user.target"];
      after = ["network-online.target"];
      environment.HOME = "/var/lib/attic-watch-store";
      serviceConfig = {
        DynamicUser = true;
        MemoryHigh = "5%";
        MemoryMax = "10%";
        LoadCredential = "prod-auth-token:${config.age.secrets.attic-key.path}";
        StateDirectory = "attic-watch-store";
      };
      path = [pkgs.attic-client];
      script = ''
        set -eux -o pipefail
        ATTIC_TOKEN=$(< $CREDENTIALS_DIRECTORY/prod-auth-token)
        # Replace https://cache.<domain> with your own cache URL.
        attic login tomas https://nix-cache.harke.ma $ATTIC_TOKEN
        attic use tomas
        exec attic watch-store tomas:tomas
      '';
    };
  };
}
