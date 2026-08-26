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

    #  Failed assertions:
    #  - FIDO2 and YubiKey may not be used at the same time.
    #  - boot.initrd.luks.fido2Support is deprecated, and it is unsupported with systemd stage 1. Support will be removed in
    #    26.11 along with scripted stage 1. Hardware keys in systemd stage 1 are supported with systemd-cryptsetup(8). To migrate,
    #    enroll a key in a LUKS slot with systemd-cryptenroll(1). Usually, systemd will automatically detect the configuration
    #    at runtime, but if necessary, configure the corresponding crypttab(5) options with boot.initrd.luks.devices.<name>.crypttabExtraOpts.

    boot = {
      initrd = {
        systemd.tpm2 = {
          enable = true;
          pcrphases.enable = true;
        };

        # kernelModules = ["tpm_rng"];
      };

      # kernelModules = ["tpm_rng"];
      # plymouth.tpm2-totp.enable = true;
    };

    environment.systemPackages = with pkgs; [
      rng-tools
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
