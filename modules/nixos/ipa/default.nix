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

    environment.etc."krb5.conf".text = ''
      [libdefaults]
      default_ccache_name = FILE:/var/cache/krb5/krb5cc_%{uid}
    '';

    services.sssd = {
      enable = true;
      kcm = true;
      sshAuthorizedKeysIntegration = true;
      # [sssd]
      # krb5_rcache_dir = /var/cache/krb5

      config = ''
        [pam]
        pam_passkey_auth = True
      '';
    };
    networking.extraHosts = ''
      100.64.198.108 ipa.harkema.intra
    '';
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
