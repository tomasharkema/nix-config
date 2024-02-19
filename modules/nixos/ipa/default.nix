{
  config,
  pkgs,
  lib,
  ...
}: {
  config = {
    system.activationScripts = {
      default_ccache_name = ''
        if [ ! -d "/var/cache/krb5" ]; then
          mkdir /var/cache/krb5
          chmod 777 /var/cache/krb5
        fi
      '';
    };

    environment.etc = {
      "krb5.conf" = {
        text = ''
          [libdefaults]
          default_ccache_name = FILE:/var/cache/krb5/krb5cc_%{uid}
        '';
      };
      "static/sssd/conf.d/99-sssd.conf" = {
        text = ''
          [sssd]
          krb5_rcache_dir = /var/cache/krb5
        '';
        mode = "0600";
      };
      "static/sssd/conf.d/98-pam.conf" = {
        text = ''
          [pam]
          pam_passkey_auth = True

        '';
        # pam_cert_auth = True
        mode = "0600";
      };
    };

    services.sssd = {
      enable = true;
      kcm = true;
      sshAuthorizedKeysIntegration = true;
      # [sssd]
      # krb5_rcache_dir = /var/cache/krb5
    };
    # networking.extraHosts = ''
    #   100.64.198.108 ipa.harkema.intra
    # '';
    security = {
      pki.certificateFiles = [./ca.crt];
      ipa = {
        enable = true;
        server = "ipa.harkema.intra";
        domain = "harkema.intra";
        realm = "HARKEMA.INTRA";
        basedn = "dc=harkema,dc=intra";
        certificate = pkgs.fetchurl {
          url = "https://ipa.harkema.intra/ipa/config/ca.crt";
          sha256 = "1479i13wzznz7986sqlpmx6r108d24kbn84yp5n3s50q7wpgdfxz";
        };
        dyndns.enable = true;
        ifpAllowedUids = ["root" "tomas"];
      };
    };
  };
}
