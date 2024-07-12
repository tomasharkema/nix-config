{
  lib,
  config,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.traits.hardware.secure-boot;
in {
  options.traits = {
    hardware.secure-boot = {
      enable = mkBoolOpt false "secure-boot lanzaboote";
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [sbctl exfatprogs];
    boot = {
      lanzaboote = {
        enable = true;
        enrollKeys = true;
        pkiBundle = "/etc/secureboot";
        # settings = {
        #   options = "vt.default_red=30,243,166,249,137,245,148,186,88,243,166,249,137,245,148,166 vt.default_grn=30,139,227,226,180,194,226,194,91,139,227,226,180,194,226,173 vt.default_blu=46,168,161,175,250,231,213,222,112,168,161,175,250,231,213,200";
        # };
        # enrollKeys = true;
      };
      loader = {
        efi.canTouchEfiVariables = lib.mkDefault true;
        systemd-boot = lib.mkIf cfg.enable {enable = false;};
        # uki.enable = true;
      };
    };
  };
}
