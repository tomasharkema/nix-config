{ lib, inputs, pkgs, config, ... }: {

  environment.interactiveShellInit =
    let
      attic-bin = lib.attrsets.getBin inputs.attic.packages.${pkgs.system}.default;
      attic-script = (pkgs.writeShellScriptBin "attic-script" ''
        ${lib.attrsets.getBin attic-bin}/bin/attic login tomas https://nix-cache.harke.ma $(cat ${config.age.secrets.attic-key.path})
        ${lib.attrsets.getBin attic-bin}/bin/attic use tomas:tomas
      '');
    in
    ''
      ${attic-script}/bin/attic-script
      #   mkdir -p ~/.1password || true
      #   ln -s ~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock /Users/tomas/.1password/agent.sock || true
      #   export SSH_AUTH_SOCK=/Users/tomas/.1password/agent.sock
    '';


  systemd.services.attic-watch =
    let
      attic-bin = lib.attrsets.getBin inputs.attic.packages.${pkgs.system}.default;
      attic-script = (pkgs.writeShellScriptBin "attic-script" ''
        ${lib.attrsets.getBin attic-bin}/bin/attic login tomas https://nix-cache.harke.ma $(cat ${config.age.secrets.attic-key.path})
        ${lib.attrsets.getBin attic-bin}/bin/attic use tomas:tomas
        ${lib.attrsets.getBin attic-bin}/bin/attic watch-store tomas:tomas
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
      script = "${lib.attrsets.getBin attic-script}/bin/attic-script";
      wantedBy = [ "multi-user.target" ];
      path = [ attic-bin attic-script ];
      environment = {
        ASSUME_NO_MOVING_GC_UNSAFE_RISK_IT_WITH = "go1.21";
      };
    };
}
