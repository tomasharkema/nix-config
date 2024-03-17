{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.apps.ipa;
in {
  disabledModules = [
    "security/ipa.nix"
    "security/pam.nix"
    "krb5/default.nix"
    "config/krb5/default.nix"
    "services/misc/sssd.nix"
  ];

  imports = [
    "${inputs.unstable}/nixos/modules/security/ipa.nix"
    "${inputs.unstable}/nixos/modules/security/pam.nix"
    "${inputs.unstable}/nixos/modules/security/krb5"
    "${inputs.unstable}/nixos/modules/services/misc/sssd.nix"
  ];

  options = {
    apps.ipa = {
      enable = mkEnableOption "enable ipa";
    };
    services.intune.enable = mkEnableOption "intune";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [ldapvi ldapmonitor];

    security = {
      polkit = {
        enable = true;
        extraConfig = ''
          polkit.addRule(function(action, subject) {
            if (action.id == "org.freedesktop.policykit.exec" && subject.isInGroup("admins")) {
              return polkit.Result.YES;
            }
          });
        '';
      };

      pam = {
        services = {
          login.sssdStrictAccess = mkDefault true;
          sudo.sssdStrictAccess = mkDefault true;
          ssh.sssdStrictAccess = mkDefault true;
        };
      };
    };

    services.sssd = {
      enable = true;
      # kcm = true;
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
        ifpAllowedUids = ["root" "tomas"];
      };
    };
  };
}
