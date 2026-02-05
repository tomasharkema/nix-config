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
    enable = lib.mkEnableOption "hardware tpm";
  };

  config = lib.mkIf cfg.enable {
    system.nixos.tags = ["tpm"];

    services = {
      ssh-tpm-agent.enable = lib.mkDefault true;

      # jitterentropy-rngd.enable = true;
    };

    security.tpm2 = {
      enable = true;
      applyUdevRules = true;
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
        systemd.tpm2.enable = true;

        # kernelModules = ["tpm_rng"];
      };

      # kernelModules = ["tpm_rng"];
      # plymouth.tpm2-totp.enable = true;
    };

    environment.systemPackages = with pkgs; [
      rng-tools
      #   tpm-luks
      # tpm-tools
      tpm2-abrmd
      tpm2-pkcs11
      tpm2-openssl
      tpm2-tools
      tpm-fido
      tpm2-totp
      tpm2-tss
      tpmmanager
    ];
  };
}
