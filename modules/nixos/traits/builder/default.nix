{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.traits.builder;
in {
  imports = with inputs; [
    vscode-server.nixosModules.default
  ];

  options.traits = {
    builder = {
      enable = mkBoolOpt false "SnowflakeOS GNOME configuration";
    };
  };

  config = mkIf cfg.enable {
    apps.attic.enable = true;
    services.hydra = {
      enable = true;
      hydraURL = "https://hydra.harkema.io";
      notificationSender = "tomas+hydra@harkema.io";
      buildMachinesFiles = [];
      useSubstitutes = true;
    };
    programs.nix-ld.enable = true;

    nix.sshServe = {
      enable = true;
      keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILgD7me/mlDG89ZE/tLTJeNhbo3L+pi7eahB2rUneSR4 tomas@tomas"
      ];
    };

    services.vscode-server.enable = true;
  };
}
