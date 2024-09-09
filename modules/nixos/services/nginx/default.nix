{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.proxy-services;

  certPath = "${cfg.crt.crt}";
  keyPath = "${cfg.crt.key}";
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
        default = "/etc/ssl/private/tailscale.key";
        description = "vhost";
      };

      crt = lib.mkOption {
        type = lib.types.str;
        default = "/etc/ssl/certs/tailscale.crt";
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

        sslCertificate = "${certPath}";
        sslCertificateKey = "${keyPath}";

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

    users.groups = {
      "ssl-cert" = {members = ["root" "tomas" "nginx" "tailscale"];};
    };

    networking.firewall.allowedTCPPorts = [80 443];

    systemd = {
      #tmpfiles.rules = [
      #  "d '${cfg.cert.dir}' 0660 root ssl-cert -"
      #  "Z '${cfg.cert.dir}' 0660 root ssl-cert"
      #  "f '${keyPath}' 0640 root ssl-cert - -"
      #  "f '${certPath}' 0660 root ssl-cert - -"
      #];

      #paths.tailscale-cert-location = {
      #  description = "tailscale-cert";
      #  wantedBy = []; # ["multi-user.target"];
      #  # This file must be copied last
      #  pathConfig.PathExists = [certPath keyPath];
      #};

      services.tailscale-cert = {
        enable = true;
        description = "tailscale-cert";

        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };
        # script = ''
        # mkdir "${cfg.cert.dir}" || true
        script = ''
          cert_dir="$(dirname "${certPath}")"
          key_dir="$(dirname "${keyPath}")"

          mkdir -p "$cert_dir" || true
          mkdir -p "$key_dir" || true

          ${
            lib.getExe pkgs.tailscale
          } cert --cert-file "${certPath}" --key-file "${keyPath}" "${cfg.vhost}"

          chown -R nginx:ssl-cert "${keyPath}"
        '';
        #chmod 664 -R "${cfg.cert.dir}"
        #chown nginx:ssl-cert -R "${cfg.cert.dir}"

        # mkdir -p /etc/nginx/ssl/
        # cp -r "${cfg.cert.dir}" /etc/nginx/ssl/
        # chown nginx:nginx -R /etc/nginx/ssl/
        # '';
        # mkdir -p "${cfg.dir}"
        # chown root:ssl-cert -R "${cfg.dir}"
        # chmod 660 -R "${cfg.dir}"

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
