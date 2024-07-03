{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.ecrypt;
in {
  options.ecrypt.enable = mkEnableOption "ecryptfs";

  config = mkIf cfg.enable {
    security.pam.enableEcryptfs = true;

    boot.kernelModules = ["ecryptfs"];

    programs.ecryptfs.enable = true;

    environment.systemPackages = with pkgs; [ecryptfs-helper];
  };
}
