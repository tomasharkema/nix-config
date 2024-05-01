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

    services = {
      autofs = {
        # enable = true;
      };
      sssd = {
        enable = true;
        # kcm = true;
        sshAuthorizedKeysIntegration = true;

        # config = ''
        #   [pam]
        #   pam_passkey_auth = True
        #   passkey_debug_libfido2 = True

        #   [prompting/passkey]
        #   interactive_prompt = "Insert your Passkey device, then press ENTER."

        #   [domain/shadowutils]
        #   id_provider = proxy
        #   proxy_lib_name = files
        #   auth_provider = none
        #   local_auth_policy = match

        # '';
      };
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
        ifpAllowedUids = ["root" "tomas" "1000"];
      };

      # sudo.package = mkIf config.installed (pkgs.sudo.override {withSssd = true;});

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
        #   krb5.enable = true;
        # services = mkIf false {
        #   #config.installed {
        #   login.sssdStrictAccess = mkDefault true;
        #   sudo.sssdStrictAccess = mkDefault true;
        #   ssh.sssdStrictAccess = mkDefault true;
        #   askpass.sssdStrictAccess = mkDefault true;
        #   cockpit.sssdStrictAccess = mkDefault true;
        #   "password-auth".sssdStrictAccess = mkDefault true;
        #   "system-auth".sssdStrictAccess = mkDefault true;
        #   "gdm-password".sssdStrictAccess = mkDefault true;
        # };
      };
    };
  };
}
