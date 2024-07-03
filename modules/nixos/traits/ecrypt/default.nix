{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.traits.ecrypt;
in {
  options.traits.ecrypt.enable = mkEnableOption "ecryptfs";

  config = mkIf cfg.enable {
    security.pam.enableEcryptfs = true;

    boot.kernelModules = ["ecryptfs"];

    programs.ecryptfs.enable = true;
  };
}
