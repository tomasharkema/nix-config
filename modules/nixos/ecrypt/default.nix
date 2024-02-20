{
  pkgs,
  lib,
  config,
  ...
}: {
  config = {
    security.pam.enableEcryptfs = true;
    boot.kernelModules = ["ecryptfs"];
    environment.systemPackages = with pkgs; [ecryptfs];
  };
}
