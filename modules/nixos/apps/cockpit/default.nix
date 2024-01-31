{
  lib,
  pkgs,
  config,
  ...
}: let
  cockpit-podman = pkgs.callPackage ./cockpit-podman.nix {};
  # cockpit-tailscale = pkgs.callPackage ./cockpit-tailscale.nix {};
in {
  config = {
    services.cockpit = {
      enable = true;
      port = 9090;
      settings = {
        WebService = {
          # AllowUnencrypted = false;
          UrlRoot = "/cockpit/";
        };
      };
    };
    environment.systemPackages = with pkgs; [
      cockpit-podman
      # cockpit-tailscale
    ];

    services.nginx = {
      virtualHosts."${config.proxy-services.vhost}" = {
        locations = {
          "/" = {
            return = "301 https://${config.proxy-services.vhost}/cockpit/";
          };
          # "/cockpit" = {
          #   return = "301 https://${config.proxy-services.vhost}/cockpit/";
          # };
          # "^~ /cockpit/" = {
          "/cockpit/" = {
            proxyPass = "http://localhost:9090";
            # extraConfig = ''
            #   rewrite /cockpit(.*) $1 break;
            # '';
          };
        };
      };
    };

    # systemd.services.cockpit-tailscale-cert = {
    #   enable = true;
    #   description = "cockpit-tailscale-cert";
    #   unitConfig = {
    #     Type = "oneshot";
    #     StartLimitIntervalSec = 500;
    #     StartLimitBurst = 5;
    #   };
    #   script = "${lib.getExe cockpit-get-cert}";
    #   wantedBy = ["multi-user.target"];
    #   after = ["tailscale.service"];
    #   wants = ["tailscale.service"];
    #   path = [cockpit-get-cert pkgs.tailscale];
    # };

    # environment.etc = {
    #   "pam.d/cockpit".text = lib.mkForce ''
    #     # Account management.
    #     account required pam_unix.so # unix (order 10900)

    #     # Authentication management.
    #     auth sufficient pam_unix.so likeauth try_first_pass # unix (order 11600)
    #     auth required pam_deny.so # deny (order 12400)

    #     # Password management.
    #     password sufficient pam_unix.so nullok yescrypt # unix (order 10200)

    #     # Session management.
    #     session required pam_env.so conffile=/etc/pam/environment readenv=0 # env (order 10100)
    #     session required pam_unix.so # unix (order 10200)
    #     session required /nix/store/nhbab2wcqcz5sds4c2ki89lyqsfpiscs-linux-pam-1.5.2/lib/security/pam_limits.so conf=/nix/store/b2c1pdvnmqaib1gpkz6awjhjy69i1jza-limits.conf # limits (order 12200)

    #     auth required pam_google_authenticator.so nullok
    #   '';
    # };
  };
}
