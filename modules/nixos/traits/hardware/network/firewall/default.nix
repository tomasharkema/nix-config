{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.traits.hardware.network.firewall;
in {
  options.traits.hardware.network.firewall = {
    enable = lib.mkEnableOption "firewall";

    daemon.enable = lib.mkEnableOption "firewall" // {default = true;};
  };

  config = lib.mkIf cfg.enable {
    networking = {
      firewall = {
        enable = true;
        allowPing = true;
        allowedUDPPorts = [53 67];
      };

      nftables.enable = true;
    };

    environment.systemPackages = with pkgs;
      lib.mkIf cfg.daemon.enable [
        firewalld-gui
      ];

    services = lib.mkIf cfg.daemon.enable {
      firewalld.enable = lib.mkDefault true;
    };
  };
}
