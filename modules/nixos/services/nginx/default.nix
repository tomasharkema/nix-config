{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.proxy-services;

  certPath = "${cfg.cert.dir}/${cfg.cert.crt}";
  keyPath = "${cfg.cert.dir}/${cfg.cert.key}";
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

    cert = {
      dir = mkOption {
        type = types.path;
        default = "/var/lib/tailscale-cert";
        description = "vhost";
      };

      key = mkOption {
        type = types.str;
        default = "tailscale.key";
        description = "vhost";
      };

      crt = mkOption {
        type = types.str;
        default = "tailscale.crt";
        description = "vhost";
      };
    };
  };

  config = mkIf cfg.enable {
    services.nginx = {
      enable = true;
      recommendedProxySettings = true;
      recommendedTlsSettings = true;

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
            "/basic_status" = {
              extraConfig = ''stub_status;'';
            };
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

    users.groups = {
      "ssl-cert" = {
        members = ["root" "tomas" "nginx" "tailscale"];
      };
    };

    networking.firewall.allowedTCPPorts = [80 443];

    systemd = {
      tmpfiles.rules = [
        "d '${cfg.cert.dir}' 0770 root ssl-cert -"
        "Z '${cfg.cert.dir}' 0770 root ssl-cert"
        "f '${keyPath}' 0770 root ssl-cert - -"
        "f '${certPath}' 0770 root ssl-cert - -"
      ];

      paths.tailscale-cert-location = {
        description = "tailscale-cert";
        wantedBy = []; # ["multi-user.target"];
        # This file must be copied last
        pathConfig.PathExists = [certPath keyPath];
      };

      services.tailscale-cert = {
        description = "tailscale-cert-refresh";

        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };
        script = ''
          ${lib.getExe pkgs.tailscale} cert --cert-file "${certPath}" --key-file "${keyPath}" ${cfg.vhost}
        '';
        # mkdir -p "${cfg.dir}"
        # chown root:ssl-cert -R "${cfg.dir}"
        # chmod 660 -R "${cfg.dir}"

        # wantedBy = ["multi-user.target" "network.target"];
        # after = ["tailscaled.service" "network.target"];
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
      enable = true;

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
