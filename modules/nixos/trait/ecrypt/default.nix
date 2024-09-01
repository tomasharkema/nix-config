{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.trait.ecrypt;
in {
  options.trait.ecrypt.enable = mkEnableOption "ecryptfs";

  config = mkIf cfg.enable {
    security.pam.enableEcryptfs = true;

    boot.kernelModules = ["ecryptfs"];

    programs.ecryptfs.enable = true;
  };
}
