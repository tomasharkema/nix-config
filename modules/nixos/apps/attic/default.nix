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
  options.apps.attic = {
    enable = mkBoolOpt false "enable attic conf";
  };

  config = let
    attic-login = writeShellScriptBin "attic-script" ''
      ${attic}/bin/attic login tomas https://nix-cache.harke.ma $(cat ${config.age.secrets.attic-key.path})
      ${attic}/bin/attic use tomas:tomas
    '';
  in
    mkIf cfg.enable {
      systemd.user.services.attic-login = {
        description = "attic-login";
        script = "${lib.getExe attic-login}";
        wantedBy = ["multi-user.target"]; # starts after login
        unitConfig = {
          Type = "oneshot";
        };
      };

      services.cachix-watch-store = {
        enable = true;
        cacheName = "tomasharkema";
        cachixTokenFile = config.age.secrets.cachix-token.path;
      };

      systemd.services.cachix-watch-store-agent.serviceConfig.MemoryMax = "2G";

      environment.systemPackages = with pkgs; [attic];

      # services.cachix-agent = {
      #   enable = true;
      # };

      systemd.services.attic-watch = {
        enable = true;
        description = "attic-watch";
        unitConfig = {
          Type = "simple";
          StartLimitIntervalSec = 500;
          StartLimitBurst = 5;
        };
        serviceConfig = {
          Restart = "on-failure";
          RestartSec = 5;
          MemoryLimit = "2G";
        };
        preStart = "${lib.getExe attic-login}";
        script = "${attic}/bin/attic watch-store tomas:tomas";
        wantedBy = ["multi-user.target"];
        environment = {
          ASSUME_NO_MOVING_GC_UNSAFE_RISK_IT_WITH = "go1.21";
        };
      };
    };
}
