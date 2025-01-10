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
  };

  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [sbctl exfatprogs];
    boot = {
      lanzaboote = {
        enable = true;
        # enrollKeys = true;
        pkiBundle = "/var/lib/sbctl";

        configurationLimit = 10;
      };
      loader = {
        efi.canTouchEfiVariables = lib.mkDefault true;
        systemd-boot = lib.mkIf cfg.enable {enable = false;};
        # uki.enable = true;
      };
    };
  };
}
