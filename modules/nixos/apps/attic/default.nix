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
  attic-pkg = inputs.attic.packages.${system}.default;
  attic-bin = "${attic-pkg}/bin/attic";
in {
  options.apps.attic = {
    enable = mkBoolOpt false "SnowflakeOS GNOME configuration";
  };

  # age.secrets.attic-key = {
  #   file = ../secrets/attic-key.age;
  # };

  config = mkIf cfg.enable {
    systemd.user.services.attic-login = let
      attic-login = writeShellScriptBin "attic-script" ''
        ${attic-bin} login tomas https://nix-cache.harke.ma $(cat ${config.age.secrets.attic-key.path})
        ${attic-bin} use tomas:tomas
      '';
    in {
      description = "attic-login";
      script = "${attic-login}";
      wantedBy = ["multi-user.target"]; # starts after login
      unitConfig.Type = "oneshot";
    };

    systemd.services.attic-watch = let
      attic-script = writeShellScriptBin "attic-script.sh" ''
        ${attic-bin} login tomas https://nix-cache.harke.ma "$(cat ${config.age.secrets.attic-key.path})"
        ${attic-bin} use tomas:tomas
        ${attic-bin} watch-store tomas:tomas
      '';
    in {
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
      script = "${lib.getExe attic-script}";
      wantedBy = ["multi-user.target"];
      path = [attic-bin attic-script];
      environment = {
        ASSUME_NO_MOVING_GC_UNSAFE_RISK_IT_WITH = "go1.21";
      };
    };
  };
}
