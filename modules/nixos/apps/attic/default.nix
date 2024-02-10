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

  attic = inputs.attic.packages.${system}.default;
in {
  options.apps.attic = {
    enable = mkBoolOpt false "SnowflakeOS GNOME configuration";
  };

  config = mkIf (cfg.enable && !config.traits.slim.enable) {
    # systemd.user.services.attic-login = let
    #   attic-login = writeShellScriptBin "attic-script" ''
    #     ${lib.getExe attic} login tomas https://nix-cache.harke.ma $(cat ${config.age.secrets.attic-key.path})
    #     ${lib.getExe attic} use tomas:tomas
    #   '';
    # in {
    #   description = "attic-login";
    #   script = "${lib.getExe attic-login}";
    #   wantedBy = ["multi-user.target"]; # starts after login
    #   unitConfig = {
    #     Type = "oneshot";
    #   };
    # };

    services.cachix-watch-store = {
      enable = true;
      cacheName = "tomasharkema";
      cachixTokenFile = config.age.secrets.cachix-token.path;
    };

    systemd.services.cachix-watch-store-agent.serviceConfig.MemoryMax = "4G";

    services.cachix-agent = {
      enable = true;
    };

    # systemd.services.attic-watch = let
    #   attic-script = writeShellScriptBin "attic-script.sh" ''
    #     ${lib.getExe attic} login tomas https://nix-cache.harke.ma "$(cat ${config.age.secrets.attic-key.path})"
    #     ${lib.getExe attic} use tomas:tomas
    #     ${lib.getExe attic} watch-store tomas:tomas
    #   '';
    # in {
    #   enable = true;
    #   description = "attic-watch";
    #   unitConfig = {
    #     Type = "simple";
    #     StartLimitIntervalSec = 500;
    #     StartLimitBurst = 5;
    #   };
    #   serviceConfig = {
    #     Restart = "on-failure";
    #     RestartSec = 5;
    #     MemoryLimit = "2G";
    #   };
    #   script = "${lib.getExe attic-script}";
    #   wantedBy = ["multi-user.target"];
    #   path = [attic attic-script];
    #   environment = {
    #     ASSUME_NO_MOVING_GC_UNSAFE_RISK_IT_WITH = "go1.21";
    #   };
    # };
  };
}
