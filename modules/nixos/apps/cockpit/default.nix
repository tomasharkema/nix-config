{
  lib,
  pkgs,
  config,
  ...
}: {
  config = {
    services.cockpit = {
      enable = true;
      port = 9090;
      package = pkgs.cockpit;

      settings = {
        WebService = {
          ClientCertAuthentication = true;
        };

        # WebService =
        #   if config.services.nginx.enable
        #   then {
        #     # AllowUnencrypted = false;
        #     Origins = "https://${config.proxy-services.vhost} wss://${config.proxy-services.vhost} http://localhost:9090 ws://localhost:9090";
        #     ProtocolHeader = "X-Forwarded-Proto";
        #     UrlRoot = "/cockpit";
        #   }
        #   else {};
      };
    };
    environment.pathsToLink = ["/libexec"];
    systemd = {
      services = {
        "cockpit".environment = {
          G_MESSAGES_DEBUG = lib.mkForce "cockpit-ws,cockpit-bridge";
        };

        "cockpit-session@" = {
          unitConfig = {
            Description = "Cockpit session %I";
          };
          environment = {
            G_MESSAGES_DEBUG = lib.mkForce "cockpit-ws,cockpit-bridge";
          };

          path = [
            pkgs.coreutils
            pkgs.cockpit
          ];

          serviceConfig = {
            ExecStart = "${pkgs.cockpit}/libexec/cockpit-session";
            StandardInput = "socket";
            StandardOutput = "inherit";
            StandardError = "journal";
            User = "root";
            # bridge error, authentication failure, or timeout, that's not a problem with the unit
            SuccessExitStatus = "1 5 127";
          };
        };

        "cockpit-session-socket-user" = {
          unitConfig = {
            Description = "Dynamic user for /run/cockpit/session socket";
            BindsTo = ["cockpit-session.socket"];
          };

          serviceConfig = {
            DynamicUser = "yes";
            User = "cockpit-session-socket";
            Group = "cockpit-session-socket";
            Type = "oneshot";
            ExecStart = "${pkgs.coreutils}/bin/true";
            RemainAfterExit = "yes";
          };
        };
      };
      sockets = {
        "cockpit-session" = {
          unitConfig = {
            Description = "Initiator socket for Cockpit sessions";
            PartOf = ["cockpit.service"];
            Requires = ["cockpit-session-socket-user.service"];
            After = ["cockpit-session-socket-user.service"];
          };
          socketConfig = {
            ListenStream = "/run/cockpit/session";
            SocketUser = "root";
            SocketGroup = "cockpit-session-socket";
            SocketMode = "0660";
            RemoveOnStop = "yes";
            Accept = "yes";
          };
        };
        "cockpit-session-socket-user" = {
          unitConfig = {
            Description = "Initiator socket for Cockpit sessions";
            PartOf = ["cockpit.service"];
            Requires = ["cockpit-session-socket-user.service"];
            After = ["cockpit-session-socket-user.service"];
          };
          socketConfig = {
            ListenStream = "/run/cockpit/session";
            SocketUser = "root";
            SocketGroup = "cockpit-session-socket";
            SocketMode = "0660";
            RemoveOnStop = "yes";
            Accept = "yes";
          };
        };
      };
    };

    environment.systemPackages = with pkgs; [
      cockpit-podman
      cockpit-tailscale
      cockpit-machines
      cockpit-sensors
      cockpit-files
      # packagekit
    ];

    # services.multipath = {
    #   enable = true;
    # };

    proxy-services.services = {
      "/" = {
        # default = true;
        return = "302 /cockpit/";
      };
      "/cockpit/" = {
        proxyPass = "https://localhost:9090/cockpit/";
        proxyWebsockets = true;
        extraConfig = ''
          # proxy_set_header Host $host;
          # proxy_set_header X-Forwarded-Proto $scheme;

          # # Required for web sockets to function
          # proxy_http_version 1.1;
          # proxy_buffering off;
          # proxy_set_header Upgrade $http_upgrade;
          # proxy_set_header Connection "upgrade";

          # # Pass ETag header from Cockpit to clients.
          # # See: https://github.com/cockpit-project/cockpit/issues/5239
          # gzip off;
        '';
      };
    };

    # systemd.services.cockpit-tailscale-cert = {
    #   enable = true;
    #   description = "cockpit-tailscale-cert";
    #   unitConfig = {
    #     Type = "oneshot";
    #     RemainAfterExit = "yes";
    #     StartLimitIntervalSec = 500;
    #     StartLimitBurst = 5;
    #   };
    #   script = ''
    #     ${lib.getExe pkgs.tailscale} cert \
    #       --cert-file /etc/cockpit/ws-certs.d/${config.proxy-services.vhost}.cert \
    #       --key-file /etc/cockpit/ws-certs.d/${config.proxy-services.vhost}.key \
    #       ${config.proxy-services.vhost}
    #   '';
    #   wantedBy = ["multi-user.target" "network.target"];
    #   after = ["tailscaled.service"];
    #   wants = ["tailscaled.service"];
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
