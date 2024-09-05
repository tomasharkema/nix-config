{
  osConfig,
  pkgs,
  lib,
  inputs,
  ...
}: let
  machines = inputs.self.machines.excludingSelf osConfig;

  writeINI = p: lib.generators.toINI {} p;
in {
  config = lib.mkIf pkgs.stdenv.isLinux {
    services.remmina = {
      enable = true;
      # systemdService.enable = true;
    };

    home.file = builtins.listToAttrs (map (machine: {
        name = ".local/share/remmina/nixos_rdp_${machine}_${machine}.remmina";
        value = {
          text = writeINI {
            remmina = {
              name = machine;
              group = "nixos";
              server = machine;
              protocol = "RDP";
              labels = machine;
              username = "tomas";
            };
          };
        };
      })
      machines);

    editor = {
      enable = true;
      modifications = (
        map (machine: {
          path = "/home/tomas/.local/share/remmina/nixos_rdp_${machine}_${machine}.remmina";
          type = "ini";
          modifications = writeINI {
            remmina = {
              name = machine;
              group = "nixos";
              server = machine;
              protocol = "RDP";
              labels = machine;
              username = "tomas";
            };
          };
        })
        machines
      );
    };
  };
}
