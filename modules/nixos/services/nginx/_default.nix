{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.proxy-services;

  certPath = cfg.crt.crt;
  keyPath = cfg.crt.key;
in {
  options.proxy-services = {
    enable = lib.mkEnableOption "enable nginx";

    vhost = lib.mkOption {
      type = lib.types.str;
      default = "${config.networking.hostName}.ling-lizard.ts.net";
      description = "vhost";
    };

    services = lib.mkOption {
      type = lib.types.attrs;
      default = {};
      description = "services";
    };

    crt = {
      key = lib.mkOption {
        type = lib.types.str;
        default = "/etc/nginx/ssl/${cfg.vhost}.key";
        description = "vhost";
      };

      crt = lib.mkOption {
        type = lib.types.str;
        default = "/etc/nginx/ssl/${cfg.vhost}.crt";
        description = "vhost";
      };
    };
  };

  config = lib.mkIf cfg.enable {
    services.nginx = {
      enable = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;
      statusPage = true;

      # recommendedBrotliSettings = true;
      # recommendedGzipSettings = true;
      # recommendedOptimisation = true;
      # recommendedZstdSettings = true;

      virtualHosts."${cfg.vhost}" = {
        forceSSL = true;

        sslCertificate = certPath;
        sslCertificateKey = keyPath;

        locations =
          {
            # "/webhook" = {
            #   return = "302 /webhook/";
            # };
            #     "/webhook" = {
            #       proxyPass = "http://localhost:${builtins.toString config.services.webhook.port}";
            #       extraConfig = ''
            #         rewrite /webhook(.*) $1 break;
            #       '';
            #     };
          }
          // config.proxy-services.services;
      };
    };

    # users.groups = {
    #   "ssl-cert" = {members = ["root" "tomas" "nginx" "tailscale"];};
    # };

    networking.firewall.allowedTCPPorts = [80 443];

    systemd = {
      timers.tailscale-cert = {
        description = "Renew Tailscale cert";

        timerConfig = {
          OnCalendar = "monthly";
          Unit = "%i.service";
          Persistent = true;
        };
        wantedBy = ["timers.target"];
      };

      services.tailscale-cert = let
        tailscale = lib.getExe pkgs.tailscale;
      in {
        enable = true;
        description = "tailscale-cert";

        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          WorkingDirectory = "/etc/nginx/ssl";
        };

        script = ''
          ${tailscale} cert "${cfg.vhost}"
          chown nginx:nginx *
        '';

        wantedBy = ["multi-user.target" "tailscaled.service" "network.target"];
        after = ["multi-user.target" "tailscaled.service" "network.target"];
        # wants = ["tailscaled.service"];
      };

      # services.nginx = {
      #   requires = ["tailscale-cert-location.path"];
      #   wants = ["tailscale-cert-location.path"];
      # };
    };
    # security.acme = {
    #   acceptTerms = true;
    #   defaults.email = "tomas@harkema.io";
    # };

    services.webhook = {
      #enable = true;

      hooks = {
        # upload-current-system = let
        #   push-cachix = pkgs.writeShellScriptBin "push-cachix" ''
        #     whoami
        #     ${lib.getExe pkgs.cachix} push tomasharkema /nix/var/nix/profiles/system
        #   '';
        # in {
        #   execute-command = "${lib.getExe push-cachix}";
        #   # response-message = "done";
        #   include-command-output-in-response = true;
        # };
        echo = {
          execute-command = "date";
          # response-message = "Webhook is reachable!";

          include-command-output-in-response = true;
        };
      };
    };
  };
}
