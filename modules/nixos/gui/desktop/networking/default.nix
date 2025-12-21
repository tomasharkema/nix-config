{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.gui.desktop;
in {
  config = lib.mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      firewalld-gui
      dnsmasq
    ];

    services = {
      firewalld.enable = true;
    };

    networking = {
      networkmanager.enable = true;

      usePredictableInterfaceNames = false;

      firewall = {
        enable = true;
        allowPing = true;
        allowedUDPPorts = [53 67];
      };

      nftables.enable = true;
    };
  };
}
