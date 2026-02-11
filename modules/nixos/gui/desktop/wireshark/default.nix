{
  lib,
  pkgs,
  config,
  inputs,
  ...
}: let
  cfg = config.gui.desktop;
in {
  config = lib.mkIf cfg.enable {
    programs.wireshark = {
      enable = true;
      usbmon.enable = true;
      dumpcap.enable = true;
    };
  };
}
