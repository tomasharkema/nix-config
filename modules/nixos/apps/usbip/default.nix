{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.apps.usbip;
in {
  options.apps.usbip = {
    enable = lib.mkEnableOption "usbip";
  };

  config = lib.mkIf cfg.enable {
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
