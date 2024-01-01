{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.traits.hardware.tpm;
in {
  options.traits = {
    hardware.tpm = {
      enable = mkBoolOpt false "SnowflakeOS GNOME configuration";
    };
  };

  config = mkIf cfg.enable {
    security.tpm2 = {
      enable = true;
      pkcs11.enable = true;
      tctiEnvironment.enable = true;
      abrmd.enable = true;
    };

    users.users."tomas".extraGroups = ["tss"];

    boot.initrd.systemd.enableTpm2 = true;

    services.tcsd.enable = true;

    environment.systemPackages = with pkgs; [
      tpm2-tss
      tpm-luks
      tpm2-totp
      tpm-tools
      tpmmanager
      tpm2-tools
      tpm2-abrmd
      tpm2-pkcs11
    ];
  };
}
