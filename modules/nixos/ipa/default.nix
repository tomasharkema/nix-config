{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.apps.ipa;
in {
  options.apps.ipa = {
    enable = mkEnableOption "enable ipa";
  };

  config = mkIf cfg.enable {
    system.activationScripts = {
      default_ccache_name = ''
        if [ ! -d "/var/cache/krb5" ]; then
          mkdir /var/cache/krb5
          chmod 777 /var/cache/krb5
        fi
      '';
    };

    environment.systemPackages = with pkgs; [ldapvi ldapmonitor];

    environment.etc = {
      "krb5.conf" = {
        text = ''
          [libdefaults]
          default_ccache_name = FILE:/var/cache/krb5/krb5cc_%{uid}
        '';
      };
      "static/sssd/conf.d/98-pam.conf" = {
        text = ''
          [domain/harkema.intra]
          cache_credentials = True
          debug_level = 6

          [pam]
          pam_passkey_auth = True
          passkey_debug_libfido2 = True
          # pam_cert_auth = True

          [sssd]
          krb5_rcache_dir = /var/cache/krb5

          [prompting/passkey]
          interactive = "ojoo"
        '';
        # pam_cert_auth = True
        mode = "0600";
      };
    };

    security = {
      polkit = {
        enable = true;
        extraConfig = ''
          polkit.addRule(function(action, subject) {
              if (action.id == "org.freedesktop.policykit.exec" &&
                  subject.isInGroup("admins")) {
                  return polkit.Result.YES;
              }
          });
        '';
      };

      pam = {
        services = {
          login.sssdStrictAccess = true;
          sudo.sssdStrictAccess = true;
          ssh.sssdStrictAccess = true;
        };
      };
    };

    services.sssd = {
      enable = true;
      kcm = true;
      sshAuthorizedKeysIntegration = true;
    };

    security = {
      # pki.certificateFiles = [./ca.crt];
      ipa = {
        enable = true;
        server = "ipa.harkema.intra";
        domain = "harkema.intra";
        realm = "HARKEMA.INTRA";
        basedn = "dc=harkema,dc=intra";
        # certificate = pkgs.fetchurl {
        #   url = "https://ipa.harkema.intra/ipa/config/ca.crt";
        #   sha256 = "1479i13wzznz7986sqlpmx6r108d24kbn84yp5n3s50q7wpgdfxz";
        # };
        certificate = "${./ca.crt}";
        dyndns.enable = true;
        # ifpAllowedUids = ["root" "tomas"];
      };
    };
  };
}
