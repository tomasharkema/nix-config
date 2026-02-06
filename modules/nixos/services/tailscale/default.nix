{
  config,
  pkgs,
  modulesPath,
  lib,
  ...
}: let
  cfg = config.tailscale;
in {
  options.tailscale = {
    enable = lib.mkEnableOption "tailscale" // {default = true;};
  };

  # age.secrets.tailscale = {
  #   rekeyFile = ../../secrets/tailscale.age;
  #   # mode = "770";
  #   owner = "tomas";
  #   group = "tomas";
  # };

  config = lib.mkIf cfg.enable {
    # age.secrets.zerotier = {
    #   rekeyFile = ./zerotier.age;
    # };

    networking = {
      # useDHCP = false;

      firewall = {
        trustedInterfaces = [
          "tailscale0"
          # "zthnhagpcb"
        ];
        allowedTCPPorts = [config.services.tailscale.port];
        allowedUDPPorts = [config.services.tailscale.port];
        checkReversePath = "loose";
      };
    };

    systemd.services.tailscaled.serviceConfig.Environment = [
      "TS_DEBUG_FIREWALL_MODE=nftables"
    ];

    services = {
      resolved = {
        enable = true;
        settings.Resolve = {
          MulticastDNS = "no";
        };
      };

      tailscale = {
        enable = true;
        package = pkgs.tailscale;
        # authKeyFile = config.age.secrets.tailscale.path;
        useRoutingFeatures = lib.mkDefault "both";
        extraUpFlags = [
          # "--advertise-tags=tag:nixos"
          "--operator=tomas"
          "--accept-dns"
          # "--accept-routes"
        ];
        openFirewall = true;
      };

      # tailscaleAuth.enable = true;
      # nginx.tailscaleAuth.enable = true;

      # zerotierone = {
      #   enable = true;
      #   joinNetworks = [];
      # };
    };

    # systemd.services = {
    #   zerotier-networks = {
    #     enable = true;
    #     description = "zerotier-networks";
    #     path = [
    #       config.services.zerotierone.package
    #       pkgs.jq
    #     ];

    #     wantedBy = ["zerotierone.service"];

    #     script = ''
    #       rm -rf /var/lib/zerotier-one/networks.d/*

    #       if [ -f "$CREDENTIALS_DIRECTORY/zerotier-network" ]; then
    #         network="$(cat $CREDENTIALS_DIRECTORY/zerotier-network | jq -r)"
    #         touch "/var/lib/zerotier-one/networks.d/$network.conf"
    #       else
    #         echo "No zerotier network configured."
    #         exit 1
    #       fi
    #     '';

    #     serviceConfig = {
    #       LoadCredential = "zerotier-network:${config.age.secrets.zerotier.path}";
    #       Type = "oneshot";
    #       RemainAfterExit = true;
    #     };
    #   };
    # };
  };
}
