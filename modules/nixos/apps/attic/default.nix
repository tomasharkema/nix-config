{
  lib,
  inputs,
  pkgs,
  config,
  ...
}:
with lib;
with lib.custom;
with pkgs; let
  cfg = config.apps.attic;
in {
  options.apps.attic = with lib.types; {
    enable = mkBoolOpt false "enable attic conf";

    user = mkOption {
      default = "tomas";
      type = str;
    };

    serverName = mkOption {
      default = "tomas";
      type = str;
    };
    serverAddress = mkOption {
      default = "https://nix-cache.harke.ma/";
      type = str;
    };
  };

  config = let
    attic-login = writeShellScript "attic-script" ''
      ${pkgs.attic}/bin/attic login tomas https://nix-cache.harke.ma/ $(cat ${config.age.secrets.attic-key.path})
      ${pkgs.attic}/bin/attic use tomas:tomas
    '';
  in
    mkIf cfg.enable {
      systemd.user.services.attic-login = {
        description = "attic-login";
        script = ''${attic-login}'';

        wants = ["multi-user.target" "network.target"];
        after = ["multi-user.target" "network.target"];

        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };
      };

      environment.systemPackages = with pkgs; [attic];

      systemd.services.attic-watch = {
        enable = true;
        description = "attic-watch";
        unitConfig = {
          StartLimitIntervalSec = 500;
          StartLimitBurst = 5;
        };
        serviceConfig = {
          RestartSec = 5;
          MemoryHigh = "4G";
          MemoryMax = "5G";
          Nice = 15;
        };
        preStart = ''
          ${attic-login}
        '';
        script = "${pkgs.attic}/bin/attic watch-store tomas:tomas -j 1";
        wants = ["multi-user.target" "network.target"];
        after = ["multi-user.target" "network.target"];
      };
    };
}
