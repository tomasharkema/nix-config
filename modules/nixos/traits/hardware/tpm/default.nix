{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.traits.hardware.tpm;
  # https://nixos.wiki/wiki/TPM
in {
  options.traits.hardware.tpm = {
    enable = lib.mkEnableOption "SnowflakeOS GNOME configuration";
  };

  config = lib.mkIf cfg.enable {
    system.nixos.tags = ["tpm"];

    services = {
      ssh-tpm-agent.enable = lib.mkDefault true;

      # jitterentropy-rngd.enable = true;
    };

    security.tpm2 = {
      enable = true;

      pkcs11.enable = true;

      tctiEnvironment.enable = true;
      abrmd.enable = true;
    };

    users.users = {
      "tomas".extraGroups = ["tss"];
      "root".extraGroups = ["tss"];
    };

    boot = {
      initrd = {
        systemd.enableTpm2 = true;
        # kernelModules = ["tpm_rng"];
      };

      kernelModules = ["tpm_rng"];
    };

    environment.systemPackages = with pkgs; [
      rng-tools
      #   tpm-luks
      # tpm-tools
      #   # tpm2-abrmd
      # tpm2-pkcs11
      tpm2-tools
      #   # tpm2-totp
      #   # tpm2-tss
      tpmmanager
    ];
  };
}
