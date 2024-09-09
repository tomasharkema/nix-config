{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.trait.ecrypt;
in {
  options.trait.ecrypt.enable = lib.mkEnableOption "ecryptfs";

  config = lib.mkIf cfg.enable {
    security.pam.enableEcryptfs = true;

    boot.kernelModules = ["ecryptfs"];

    programs.ecryptfs.enable = true;
  };
}
