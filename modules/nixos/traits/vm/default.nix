{
  config,
  pkgs,
  lib,
  nixpkgs,
  modulesPath,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.traits.vm;
in {
  options.traits = {
    vm = {
      enable = mkBoolOpt false "SnowflakeOS GNOME configuration";
    };
  };

  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    "${nixpkgs}/nixos/modules/profiles/qemu-guest.nix"
  ];

  config = mkIf cfg.enable {
    services.spice-vdagentd.enable = true;
  };
}
