{ config, pkgs, modulesPath, lib, ... }: {

  #   keys = lib.mkIf ("${deployment}" != "") {
  #     deployment.keys."tailscale.key" = {
  #       # Alternatively, `text` (string) or `keyFile` (path to file)
  #       # may be specified.
  #       keyCommand =
  #         [ "op" "item" "get" "nixos-tailscale" "--fields" "password" ];

  #       user = "root"; # Default: root
  #       group = "root"; # Default: root
  #       permissions = "0640"; # Default: 0600
  #       # permissions = "0777";
  #       uploadAt =
  #         "pre-activation"; # Default: pre-activation, Alternative: post-activation
  #     };
  #   };

  services.tailscale = {
    enable = true;
    # authKeyFile = "/run/keys/tailscale.key";
    authKeyFile = ../files/tailscalekey.conf;
    useRoutingFeatures = "client";
    extraUpFlags = [ "--ssh" "--advertise-tags=tag:nixos" ];
  };
  networking.nftables.enable = true;

  networking.firewall.trustedInterfaces = [ "tailscale0" ];
  networking.firewall.allowedUDPPorts = [ config.services.tailscale.port ];
}
