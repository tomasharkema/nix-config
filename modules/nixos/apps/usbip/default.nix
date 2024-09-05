{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.apps.usbip;
in {
  options.apps.usbip = {
    enable = mkEnableOption "usbip";
  };

  config = mkIf cfg.enable {
    # environment.systemPackages = with pkgs; [
    #   config.boot.kernelPackages.usbip
    #   custom.usbip-gui
    # ];
    # boot.kernelModules = [
    #   "vhci-hcd"
    #   "usbip_host"
    #   "usbip_core"
    # ];
  };
}
