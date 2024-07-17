{
  osConfig,
  pkgs,
  lib,
  inputs,
  ...
}:
with lib; let
  machines = inputs.self.machines.excludingSelf osConfig;
in {
  config = mkIf pkgs.stdenv.isLinux {
    services.remmina = {
      enable = true;
      systemdService.enable = true;
    };

    home.file = builtins.listToAttrs (map (machine: {
        name = ".local/share/remmina/nixos_rdp_${machine}_${machine}.remmina";
        value.source = pkgs.substituteAll {
          src = ./remmina-template.ini;
          inherit machine;
        };
      })
      machines);
  };
}
