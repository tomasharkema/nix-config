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
    system.nixos.tags = ["tpm"];

    security.tpm2 = {
      enable = true;

      # pkcs11.enable = true;

      tctiEnvironment.enable = true;
      # abrmd.enable = true;
    };

    users.users."tomas".extraGroups = ["tss"];
    users.users."root".extraGroups = ["tss"];

    boot.initrd.systemd.enableTpm2 = true;

    # programs.ssh.extraConfig = ''
    #   PKCS11Provider /run/current-system/sw/lib/libtpm2_pkcs11.so
    # '';

    environment.systemPackages = with pkgs; [
      tpm-luks
      tpm-tools
      # tpm2-abrmd
      # tpm2-pkcs11
      tpm2-tools
      # tpm2-totp
      # tpm2-tss
      tpmmanager
      # pkgs.custom.ssh-tpm-agent
    ];
  };
}
