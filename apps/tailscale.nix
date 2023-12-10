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

  age.secrets.tailscale.file = ../secrets/tailscale.age;
  services.tailscale = {
    enable = true;
    # authKeyFile = "/run/keys/tailscale.key";
    # authKeyFile = ../files/tailscalekey.conf;
    authKeyFile = config.age.secrets.tailscale.path;
    useRoutingFeatures = "client";
    extraUpFlags = [ "--ssh" "--advertise-tags=tag:nixos" ];
  };
  networking.nftables.enable = true;

  # networking.firewall.trustedInterfaces = [ "tailscale0" ];
  # networking.firewall.allowedUDPPorts = [ config.services.tailscale.port ];

  services.avahi.enable = true;
  # services.avahi.interfaces = [ "tailscale0" ];
  services.avahi.ipv6 = true;
  services.avahi.publish.enable = true;
  services.avahi.publish.userServices = true;
  services.avahi.publish.addresses = true;
  services.avahi.publish.domain = true;
  services.avahi.nssmdns = true;
  services.avahi.publish.workstation = true;
}
