{ pkgs, lib, config, ... }: {
  config = lib.mkIf false {
    security.pam.enableEcryptfs = true;
    boot.kernelModules = [ "ecryptfs" ];
    environment.systemPackages = with pkgs; [ ecryptfs ];
  };
}
