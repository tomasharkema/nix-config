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

    environment.systemPackages = with pkgs; [
      firewalld-gui
    ];

    services = {
      firewalld.enable = true;
    };
  };
}
