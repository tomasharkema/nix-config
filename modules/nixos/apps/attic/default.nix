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
    services.nixos-service = {
      enable = true;

      serverName = cfg.storeName;
      serverUrl = cfg.serverAddress;
      secretPath = config.age.secrets.attic-key.path;
      mode = "0777";
    };

    users.users.tomas.extraGroups = [config.services.nixos-service.group];

    # systemd.services.attic-watch = {
    #   description = "attic-watch";
    #   enable = true;
    #   preStart = ''
    #     ${atticBin} login "${cfg.serverName}" "${cfg.serverAddress}" "$(cat "${config.age.secrets.attic-key.path}")"
    #   '';
    #   script = ''
    #     ${atticBin} watch-store "${cfg.serverName}:${cfg.storeName}" -j1
    #   '';

    #   unitConfig = {
    #     StartLimitIntervalSec = 500;
    #     StartLimitBurst = 5;
    #   };
    #   serviceConfig = {
    #     RestartSec = 5;
    #     MemoryHigh = "4G";
    #     MemoryMax = "5G";
    #     Nice = 15;
    #   };

    #   wantedBy = [ "default.target" ];
    # };
  };
}
