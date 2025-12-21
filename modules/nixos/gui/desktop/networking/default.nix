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

    systemd.services = {
      NetworkManager = {
        serviceConfig = {
          CapabilityBoundingSet = [
            "CAP_NET_ADMIN"
            "CAP_DAC_OVERRIDE"
            "CAP_NET_RAW"
            "CAP_NET_BIND_SERVICE"
            "CAP_SETGID"
            "CAP_SETUID"
            "CAP_SYS_MODULE"
            "CAP_AUDIT_WRITE"
            "CAP_KILL"
            "CAP_SYS_CHROOT"
            "CAP_CHOWN"
          ];
        };
      };
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
