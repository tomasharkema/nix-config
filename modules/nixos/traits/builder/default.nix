{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.traits.builder;
in {
  options.traits = {
    builder = {
      enable = mkBoolOpt false "SnowflakeOS GNOME configuration";
    };
  };

  config = mkIf cfg.enable {
    apps.attic.enable = true;
    services.hydra = {
      enable = true;
      hydraURL = "http://localhost:3000"; # externally visible URL
      notificationSender = "hydra@localhost"; # e-mail of hydra service
      # a standalone hydra will require you to unset the buildMachinesFiles list to avoid using a nonexistant /etc/nix/machines
      buildMachinesFiles = [];
      # you will probably also want, otherwise *everything* will be built from scratch
      useSubstitutes = true;
    };
    programs.nix-ld.enable = true;
  };
}
