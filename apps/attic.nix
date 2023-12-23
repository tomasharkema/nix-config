{ lib, inputs, pkgs, config, ... }: {

  age.secrets.attic-key = {
    file = ../secrets/attic-key.age;
  };

  systemd.user.services.attic-login =
    let
      attic-bin = lib.getExe inputs.attic.packages.${pkgs.system}.default;
      attic-login = (pkgs.writeShellScriptBin "attic-script" ''
        ${attic-bin} login tomas https://nix-cache.harke.ma $(cat ${config.age.secrets.attic-key.path})
        ${attic-bin} use tomas:tomas
      '');
    in
    {
      description = "attic-login";
      script = "${attic-login}";
      wantedBy = [ "multi-user.target" ]; # starts after login
      unitConfig.Type = "oneshot";
    };

  systemd.services.attic-watch =
    let
      attic-bin = lib.getExe inputs.attic.packages.${pkgs.system}.default;
      attic-script = (pkgs.writeShellScriptBin "attic-script.sh" ''
        ${attic-bin} login tomas https://nix-cache.harke.ma "$(cat ${config.age.secrets.attic-key.path})"
        ${attic-bin} use tomas:tomas
        ${attic-bin} watch-store tomas:tomas
      '');
    in
    {
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
        MemoryLimit = "1G";
      };
      script = "${lib.getExe attic-script}";
      wantedBy = [ "multi-user.target" ];
      path = [ attic-bin attic-script ];
      environment = {
        ASSUME_NO_MOVING_GC_UNSAFE_RISK_IT_WITH = "go1.21";
      };
    };
}
