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
  options = {
    apps.ipa = {
      enable = mkEnableOption "enable ipa";
    };
    # services.intune.enable = mkEnableOption "intune";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      ldapvi
      ldapmonitor
    ];

    environment.etc = {
      "krb5.conf".text = mkBefore ''
        includedir /etc/krb5.conf.d/
      '';
      "krb5.conf.d/kcm_default_ccache".text = ''
        [libdefaults]
        default_ccache_name = KCM:
      '';
      "krb5.conf.d/enable_passkey".text = ''
        [plugins]
          clpreauth = {
            module = passkey:${pkgs.sssd}/lib/sssd/modules/sssd_krb5_passkey_plugin.so
          }

          kdcpreauth = {
            module = passkey:${pkgs.sssd}/lib/sssd/modules/sssd_krb5_passkey_plugin.so
          }

      '';
    };

    # FROM: https://github.com/NixOS/nixpkgs/blob/nixos-24.05/nixos/modules/services/misc/sssd.nix
    systemd.services.sssd-kcm = {
      description = "SSSD Kerberos Cache Manager";
      requires = ["sssd-kcm.socket"];
      serviceConfig = {
        ExecStartPre = "-${pkgs.sssd}/bin/sssd --genconf-section=kcm";
        ExecStart = "${pkgs.sssd}/libexec/sssd/sssd_kcm --uid 0 --gid 0";
      };
      # restartTriggers = [
      #   settingsFileUnsubstituted
      # ];
    };
    systemd.sockets.sssd-kcm = {
      description = "SSSD Kerberos Cache Manager responder socket";
      wantedBy = ["sockets.target"];
      # Matches the default in MIT krb5 and Heimdal:
      # https://github.com/krb5/krb5/blob/krb5-1.19.3-final/src/include/kcm.h#L43
      listenStreams = ["/var/run/.heim_org.h5l.kcm-socket"];
    };

    security.krb5.settings.libdefaults.default_ccache_name = "KCM:";

    services = {
      sssd = {
        enable = true;
        # kcm = true;
        sshAuthorizedKeysIntegration = true;

        #   #   pam_cert_auth = True

        #   #   [prompting/passkey]
        #   #   interactive_prompt = "Insert your Passkey device, then press ENTER."

        config = mkAfter ''
          [pam]
          pam_passkey_auth = True
          passkey_debug_libfido2 = True
          passkey_child_timeout = 60


          [domain/shadowutils]
          id_provider = proxy
          proxy_lib_name = files
          auth_provider = none
          local_auth_policy = match


        '';

        # [sssd]
        # debug_level 0x1310
      };
    };

    # systemd.tmpfiles.rules = [
    #   "L /bin/bash - - - - /run/current-system/sw/bin/bash"
    #   "L /bin/zsh - - - - /run/current-system/sw/bin/zsh"
    # ];

    security = {
      ipa = {
        enable = true;
        server = "ipa.harkema.io";
        domain = "harkema.io";
        realm = "HARKEMA.IO";
        basedn = "dc=harkema,dc=io";
        certificate = pkgs.fetchurl {
          url = "https://ipa.harkema.io/ipa/config/ca.crt";
          sha256 = "sha256-s93HRgX4AwCnsY9sWX6SAYrUg9BrSEg8Us5QruOunf0=";
        };
        # certificate = "${./ca.crt}";
        dyndns.enable = false;
        ifpAllowedUids = [
          "root"
          "tomas"
          #"1000" "1002" "gdm" "132"
        ];
      };

      # sudo.package = (pkgs.sudo.override { withSssd = true; });

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
        krb5.enable = true;
        services = {
          #   #config.installed {
          # login.sssdStrictAccess = mkDefault true;
          # sudo.sssdStrictAccess = mkDefault true;
          # su.sssdStrictAccess = mkDefault true;
          # ssh.sssdStrictAccess = mkDefault true;
          # askpass.sssdStrictAccess = mkDefault true;
          # cockpit.sssdStrictAccess = mkDefault true;
          # "password-auth".sssdStrictAccess = mkDefault true;
          # "system-auth".sssdStrictAccess = mkDefault true;
          # "gdm-password".sssdStrictAccess = mkDefault true;

          # "gdm-launch-environment".sssdStrictAccess = mkDefault true;
          # "gdm-password".sssdStrictAccess = mkDefault true;
        };
      };
    };
  };
}
