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

    systemd = {
      timers.tailscale-cockpit-cert-renewal = {
        description = "Timer for Tailscale certificate renewal for Cockpit";
        requires = ["tailscale-cockpit-cert-renewal.service"];

        # Run once a month (Tailscale certs are valid for 90 days)
        timerConfig = {
          OnCalendar = "monthly";
          # Run 5 minutes after boot if we missed the scheduled time
          OnBootSec = "5min";

          # Add some randomization to prevent all machines renewing at once
          RandomizedDelaySec = "1h";
          Persistent = true;
        };
        wantedBy = ["timers.target"];
      };
      services.tailscale-cockpit-cert-renewal = {
        description = "Renew Tailscale certificate for Cockpit";
        after = ["network-online.target" "tailscaled.service"];
        wants = ["network-online.target"];
        path = [
          pkgs.gawk
          config.services.tailscale.package
          pkgs.python3
          pkgs.grep
        ];
        #type = "oneshot";
        script = ''
          #
          # Tailscale Certificate Renewal Script for Cockpit
          # This script renews the Tailscale certificate and updates Cockpit configuration
          #

          set -euo pipefail

          # Automatically detect the Tailscale hostname and DNS name
          HOSTNAME=$(tailscale status 2>/dev/null | head -1 | awk '{print $2}' || true)
          if [[ -z "$HOSTNAME" ]]; then
              HOSTNAME=$(tailscale status 2>/dev/null | grep -m1 "^100\." | awk '{print $2}' || true)
          fi

          if [[ -z "$HOSTNAME" ]]; then
              echo "ERROR: Could not determine Tailscale hostname"
              exit 1
          fi

          # Get the full DNS name for certificate requests
          if command -v python3 &> /dev/null; then
              DNS_NAME=$(tailscale status --json | python3 -c "import sys, json; data = json.load(sys.stdin); print(data['Self']['DNSName'].rstrip('.'))" 2>/dev/null)
          fi

          # Fallback if python3 not available or JSON parsing failed
          if [[ -z "$DNS_NAME" ]]; then
              DNS_NAME=$(tailscale status --json 2>/dev/null | grep -o '"DNSName":[[:space:]]*"[^"]*"' | cut -d'"' -f4 | sed 's/\.$//' || true)
          fi

          if [[ -z "$DNS_NAME" ]]; then
              echo "ERROR: Could not determine Tailscale DNS name"
              exit 1
          fi

          CERT_DIR="/etc/cockpit/ws-certs.d"
          CERT_FILE="$CERT_DIR/10-tailscale.cert"
          KEY_FILE="$CERT_DIR/10-tailscale.key"
          LOG_FILE="/var/log/tailscale-cockpit-cert-renewal.log"

          # Function to log messages
          log() {
              echo "[$(date '+%Y-%m-%d %H:%M:%S')] $*" | tee -a "$LOG_FILE"
          }

          # Start renewal process
          log "Starting Tailscale certificate renewal for Cockpit"
          log "Detected hostname: $HOSTNAME"

          # Request new certificate from Tailscale
          log "Requesting certificate from Tailscale..."
          if tailscale cert "$DNS_NAME"; then
              log "Certificate successfully obtained from Tailscale"
          else
              log "ERROR: Failed to obtain certificate from Tailscale"
              exit 1
          fi

          # Check if certificate files exist
          if [[ ! -f "$DNS_NAME.crt" ]] || [[ ! -f "$DNS_NAME.key" ]]; then
              log "ERROR: Certificate files not found in current directory"
              exit 1
          fi

          # Backup existing certificates if they exist
          if [[ -f "$CERT_FILE" ]]; then
              BACKUP="$CERT_FILE.$(date +%Y%m%d-%H%M%S).bak"
              log "Backing up existing certificate to $BACKUP"
              cp "$CERT_FILE" "$BACKUP"
          fi
          if [[ -f "$KEY_FILE" ]]; then
              BACKUP="$KEY_FILE.$(date +%Y%m%d-%H%M%S).bak"
              log "Backing up existing key to $BACKUP"
              cp "$KEY_FILE" "$BACKUP"
          fi

          # Copy certificate and key as separate files
          log "Installing certificate and key files..."
          cp "$DNS_NAME.crt" "$CERT_FILE"
          cp "$DNS_NAME.key" "$KEY_FILE"

          # Set proper permissions
          log "Setting permissions..."
          chmod 644 "$CERT_FILE"
          chmod 600 "$KEY_FILE"

          # Check if cockpit-ws group exists, otherwise use root
          if getent group cockpit-ws > /dev/null 2>&1; then
              chown root:cockpit-ws "$CERT_FILE"
              chown root:cockpit-ws "$KEY_FILE"
          else
              chown root:root "$CERT_FILE"
              chown root:root "$KEY_FILE"
          fi

          # Clean up temporary certificate files
          log "Cleaning up temporary files..."
          rm -f "$DNS_NAME.crt" "$DNS_NAME.key"

          # Restart Cockpit to use new certificate
          log "Restarting Cockpit service..."
          if systemctl restart cockpit.socket; then
              log "Cockpit service restarted successfully"
          else
              log "WARNING: Failed to restart Cockpit service"
              exit 1
          fi

          # Verify certificate expiration date
          if command -v openssl &> /dev/null; then
              EXPIRY=$(openssl x509 -in "$CERT_FILE" -noout -enddate | cut -d= -f2)
              log "New certificate expires: $EXPIRY"
          fi

          log "Certificate renewal completed successfully"
          exit 0
        '';
        wantedBy = ["multi-user.target"];
      };
    };

    services.cockpit = {
      enable = true;
      port = 9090;

      allowed-origins = ["localhost" "${config.networking.hostName}.ling-lizard.ts.net"];

      plugins = with pkgs; [
        cockpit-files
        cockpit-machines
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
