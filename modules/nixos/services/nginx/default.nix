{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.proxy-services;
in {
  options.proxy-services = {
    enable = mkEnableOption "enable nginx";

    vhost = mkOption {
      type = types.str;
      default = "${config.networking.hostName}.ling-lizard.ts.net";
      description = "vhost";
    };
    services = mkOption {
      type = types.attrs;
      default = {};
      description = "services";
    };
  };

  config = mkIf cfg.enable {
    services.nginx = {
      enable = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;

      recommendedBrotliSettings = true;
      recommendedGzipSettings = true;
      recommendedOptimisation = true;
      recommendedZstdSettings = true;

      virtualHosts."${cfg.vhost}" = {
        forceSSL = true;

        sslCertificate = "/etc/ssl/private/${cfg.vhost}.crt";
        sslCertificateKey = "/etc/ssl/private/${cfg.vhost}.key";

        locations =
          {
            # "/webhook" = {
            #   return = "302 /webhook/";
            # };
            "/webhook" = {
              proxyPass = "http://localhost:${builtins.toString config.services.webhook.port}";
              extraConfig = ''
                rewrite /webhook(.*) $1 break;
              '';
            };
          }
          // config.proxy-services.services;
      };
    };

    systemd.services.tailscale-cert = {
      enable = true;
      description = "tailscale-cert";
      serviceConfig = {
        Type = "oneshot";
      };

      script = ''
        (mkdir -p /etc/ssl/private/ || true) && \
        cd /etc/ssl/private/ && \
        ${lib.getExe pkgs.tailscale} cert ${cfg.vhost} && \
        chown nginx:nginx -R /etc/ssl/private/
      '';

      wantedBy = ["multi-user.target"];
      after = ["tailscale.service" "network.target" "syslog.target"];
      wants = ["tailscale.service"];
      # path = [cockpit-get-cert pkgs.tailscale];
    };

    # security.acme = {
    #   acceptTerms = true;
    #   defaults.email = "tomas@harkema.io";
    # };

    services.webhook = {
      # enable = true;

      hooks = {
        upload-current-system = let
          push-cachix = pkgs.writeShellScriptBin "push-cachix" ''
            whoami
            ${lib.getExe pkgs.cachix} push tomasharkema /nix/var/nix/profiles/system
          '';
        in {
          execute-command = "${lib.getExe push-cachix}";
          # response-message = "done";
          include-command-output-in-response = true;
        };
        echo = {
          execute-command = "date";
          # response-message = "Webhook is reachable!";

          include-command-output-in-response = true;
        };
      };
    };
  };
}
