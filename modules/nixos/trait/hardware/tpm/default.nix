{
  lib,
  config,
  pkgs,
  ...
}:
with lib; let
  cfg = config.trait.hardware.tpm;
  # https://nixos.wiki/wiki/TPM
in {
  options.trait.hardware.tpm = {
    enable = mkEnableOption "SnowflakeOS GNOME configuration";
  };

  config = mkIf cfg.enable {
    system.nixos.tags = ["tpm"];

    services.ssh-tpm-agent.enable = mkDefault true;

    security.tpm2 = {
      enable = true;

      pkcs11.enable = true;

      tctiEnvironment.enable = true;
      abrmd.enable = true;
    };

    users.users."tomas".extraGroups = ["tss"];
    users.users."root".extraGroups = ["tss"];

    boot.initrd.systemd.enableTpm2 = true;

    # environment.systemPackages = with pkgs; [
    #   tpm-luks
    #   tpm-tools
    #   # tpm2-abrmd
    #   # tpm2-pkcs11
    #   tpm2-tools
    #   # tpm2-totp
    #   # tpm2-tss
    #   tpmmanager
    # ];
  };
}
