{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.traits.hardware.secure-boot;
in {
  options.traits.hardware.secure-boot = {
    enable = lib.mkEnableOption "secure-boot lanzaboote";

    measuredBoot =
      (lib.mkEnableOption "secure-boot lanzaboote")
      // {
        default = config.traits.hardware.tpm.enable;
      };
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      sbctl
      exfatprogs
    ];
    boot = {
      lanzaboote = {
        enable = true;
        # enrollKeys = true;
        pkiBundle = "/var/lib/sbctl";

        configurationLimit = 8;
        autoGenerateKeys = {
          enable = true;
        };
        autoEnrollKeys = {
          enable = true;
          includeMicrosoftKeys = true;
          includeChecksumsFromTPM = config.traits.hardware.tpm.enable;
        };
        measuredBoot = lib.mkIf cfg.measuredBoot {
          enable = true;
          pcrs = [
            0
            1
            2
            3
            4
            7
          ];
        };
      };
      loader = {
        efi.canTouchEfiVariables = lib.mkDefault true;
        systemd-boot = lib.mkIf cfg.enable {enable = false;};
        # uki.enable = true;
      };
    };
  };
}
