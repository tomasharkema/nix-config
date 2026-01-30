{
  lib,
  pkgs,
  config,
  ...
}: {
  config = {
    environment = {
      pathsToLink = ["/libexec"];
    };

    security.pam.services."cockpit".enable = true;
    systemd.packages = [pkgs.custom.cockpit-tailscale-cert];
    services.cockpit = {
      enable = true;
      port = 9090;

      allowed-origins = ["localhost" "${config.networking.hostName}.ling-lizard.ts.net"];

      plugins = with pkgs; [
        custom.cockpit-files
        custom.cockpit-machines
        custom.cockpit-sensors
        custom.cockpit-tailscale
        custom.cockpit-dockermanager
      ];

      settings = {
        WebService =
          # if config.services.nginx.enable
          # then {
          #   AllowUnencrypted = false;
          #   # Origins = "https://localhost:9090 wss://localhost:9090 https://${config.networking.hostName}.ling-lizard.ts.net:9090 wss://${config.networking.hostName}.ling-lizard.ts.net:9090";
          #   ProtocolHeader = "X-Forwarded-Proto";
          #   UrlRoot = "/cockpit";
          #   ClientCertAuthentication = true;
          # }
          # else
          {
            # ClientCertAuthentication = true;
            Origins = lib.mkForce "https://${config.networking.hostName}.ling-lizard.ts.net:${toString config.services.cockpit.port}";
            # ProtocolHeader = "X-Forwarded-Proto";
            AllowUnencrypted = false;
            LoginTo = true;
            AllowMultiHost = true;
          };
      };
    };
    # proxy-services.services = {
    #   "/" = {
    #     # default = true;
    #     return = "302 /cockpit/";
    #   };
    #   "/cockpit/" = {
    #     proxyPass = "https://localhost:9090/cockpit/";
    #     proxyWebsockets = true;
    #     extraConfig = ''
    #       # proxy_set_header Host $host;
    #       # proxy_set_header X-Forwarded-Proto $scheme;

    #       # # Required for web sockets to function
    #       # proxy_http_version 1.1;
    #       # proxy_buffering off;
    #       # proxy_set_header Upgrade $http_upgrade;
    #       # proxy_set_header Connection "upgrade";

    #       # # Pass ETag header from Cockpit to clients.
    #       # # See: https://github.com/cockpit-project/cockpit/issues/5239
    #       # gzip off;
    #     '';
    #   };
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
