{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.traits.ecrypt;
in {
  options.traits.ecrypt = {
    enable = lib.mkEnableOption "ecryptfs";
  };

  config = lib.mkIf (cfg.enable && false) {
    security.pam.enableEcryptfs = true;

    boot.kernelModules = ["ecryptfs"];

    programs.ecryptfs.enable = true;
  };
}
