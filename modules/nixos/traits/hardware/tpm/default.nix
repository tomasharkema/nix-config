{
  lib,
  config,
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
    };
    users.users."tomas".extraGroups = ["tss"];
    boot.initrd.systemd.enableTpm2 = true;
  };
}
