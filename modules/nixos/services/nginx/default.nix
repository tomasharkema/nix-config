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

        sslCertificate = "${cfg.dir}/${cfg.crt}";
        sslCertificateKey = "${cfg.dir}/${cfg.key}";

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

    users.groups = {
      "ssl-cert" = {
        members = ["root" "tomas" "nginx" "tailscale"];
      };
    };

    systemd = {
      tmpfiles.rules = [
        "d '${cfg.dir}' 660 root ssl-cert -"
        "Z '${cfg.dir}' 660 root ssl-cert"
      ];

      services.tailscale-cert-location = {
        serviceConfig = {
          Type = "oneshot";
          ExecStart = pkgs.writeShellScript "tailscale-cert-location-script" ''
            echo "got file!"
          '';
        };
      };
      paths.tailscale-cert-location = {
        wantedBy = []; # ["multi-user.target"];
        # This file must be copied last
        pathConfig.PathExists = ["${cfg.dir + "/" + cfg.key}" "${cfg.dir + "/" + cfg.crt}"];
      };

      services.tailscale-cert = {
        enable = true;
        description = "tailscale-cert";
        serviceConfig = {
          Type = "oneshot";
          ExecStart = pkgs.writeShellScript "tailscale-cert-script" ''
            ${lib.getExe pkgs.tailscale} cert --cert-file "${cfg.dir + "/" + cfg.crt}" --key-file "${cfg.dir + "/" + cfg.key}" ${cfg.vhost}
          '';
        };

        # mkdir -p "${cfg.dir}"
        # chown root:ssl-cert -R "${cfg.dir}"
        # chmod 660 -R "${cfg.dir}"

        wantedBy = ["multi-user.target" "network.target"];
        after = ["tailscaled.service" "network.target" "syslog.target"];
        wants = ["tailscaled.service"];
      };
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
