{
  config,
  pkgs,
  lib,
  ...
}: {
  config = {
    environment.systemPackages = with pkgs; [
      veracrypt
      ecryptfs
      # ecryptfs-helper
      sirikali
    ];
    security.pam.enableEcryptfs = true;
    boot.kernelModules = ["ecryptfs"];
    programs.ecryptfs.enable = true;
  };
}
