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
    attic-login = writeShellScript "attic-script" ''
      ${attic}/bin/attic login tomas https://blue-fire.ling-lizard.ts.net/attic/ $(cat ${config.age.secrets.attic-key.path})
      ${attic}/bin/attic use tomas:tomas
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

      # services.cachix-watch-store = {
      #   enable = true;
      #   cacheName = "tomasharkema";
      #   cachixTokenFile = config.age.secrets.cachix-token.path;
      #   jobs = 1;
      #   compressionLevel = 16;
      # };

      # systemd.services.cachix-watch-store-agent.serviceConfig = {
      #   Nice = 15;
      #   MemoryLimit = "2G";
      #   MemoryHigh = "1G";
      #   MemoryMax = "2G";
      # };

      environment.systemPackages = with pkgs; [attic];

      # services.cachix-agent = {
      #   enable = true;
      # };

      systemd.services.attic-watch = {
        enable = true;
        description = "attic-watch";
        unitConfig = {
          StartLimitIntervalSec = 500;
          StartLimitBurst = 5;
        };
        serviceConfig = {
          Restart = "on-failure";
          RestartSec = 5;
          MemoryLimit = "5G";
          MemoryHigh = "2G";
          MemoryMax = "4G";
          Nice = 15;
        };
        preStart = ''
          ${attic-login}
        '';
        script = "${attic}/bin/attic watch-store tomas:tomas -j 1";
        wants = ["multi-user.target" "network.target"];
        after = ["multi-user.target" "network.target"];
        # environment = {
        #   ASSUME_NO_MOVING_GC_UNSAFE_RISK_IT_WITH = "go1.21";
        # };
      };
    };
}
