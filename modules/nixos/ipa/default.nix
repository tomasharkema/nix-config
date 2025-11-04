{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  cfg = config.apps.ipa;
  # chromePolicy = pkgs.writers.writeJSON "harkema.json" {
  #   AuthServerWhitelist = "*.harkema.io";
  #   AuthServerAllowlist = "*.harkema.io";
  # };
in {
  options = {
    apps.ipa = {
      enable = lib.mkEnableOption "enable ipa" // {default = true;};
    };
    # services.intune.enable = mkEnableOption "intune";
  };

  config = lib.mkIf (cfg.enable) {
    environment = {
      pathsToLink = ["/modules/ldb"];

      variables = {LDB_MODULES_PATH = "/run/current-system/sw/modules/ldb";};

      systemPackages = with pkgs; [
        # ldapvi
        ldb
        # ldapmonitor
        pkcs11helper
        realmd
        # heimdal
      ];

      etc = {
        "pkcs11/modules/opensc-pkcs11".text = ''
          module: ${pkgs.opensc}/lib/opensc-pkcs11.so
        '';
        "pkcs11/modules/libykcs11".text = ''
          module: ${pkgs.yubico-piv-tool}/lib/libykcs11.so
        '';

        "krb5.conf".text = lib.mkBefore ''
          includedir /var/lib/sss/pubconf/krb5.include.d/
          includedir /etc/krb5.conf.d/
        '';

        "krb5.conf.d/0-kcm".text = ''
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

        "krb5.conf.d/sssd_enable_idp".text = ''
          # Enable SSSD OAuth2 Kerberos preauthentication plugins.
          #
          # This will allow you to obtain Kerberos TGT through OAuth2 authentication.
          #
          # To disable the OAuth2 plugin, comment out the following lines.

          [plugins]
           clpreauth = {
            module = idp:${pkgs.sssd}/lib/sssd/modules/sssd_krb5_idp_plugin.so
           }

           kdcpreauth = {
            module = idp:${pkgs.sssd}/lib/sssd/modules/sssd_krb5_idp_plugin.so
           }
        '';

        "krb5.conf.d/freeipa".text = ''
          [libdefaults]
              spake_preauth_groups = edwards25519
        '';

        "sssd/conf.d".enable = false;

        "sssd/conf.d/passkey.conf" = {
          mode = "640";
          text = ''
            [pam]
            pam_passkey_auth = True
            pam_cert_auth = True
            passkey_debug_libfido2 = True
            passkey_child_timeout = 60
            debug_level = 10
          '';
        };

        # "chromium/native-messaging-hosts/eu.webeid.json".source = "${pkgs.web-eid-app}/share/web-eid/eu.webeid.json";
        # "opt/chrome/native-messaging-hosts/eu.webeid.json".source = "${pkgs.web-eid-app}/share/web-eid/eu.webeid.json";

        # "chromium/policies/managed/harkema.json".source = chromePolicy;
        # "opt/chrome/policies/managed/harkema.json".source = chromePolicy;
      };
    };

    # programs.firefox = {
    #   nativeMessagingHosts.euwebid = true;
    #   policies.SecurityDevices.p11-kit-proxy = "${pkgs.p11-kit}/lib/p11-kit-proxy.so";
    # };

    # FROM: https://github.com/NixOS/nixpkgs/blob/nixos-24.05/nixos/modules/services/misc/sssd.nix
    systemd = {
      packages = [pkgs.realmd];

      services = {
        ipa-host-mod-sshpubkey = {
          path = with pkgs; [
            freeipa
            iproute2
            jq
            gnugrep
          ];

          after = ["sssd.service" "network-online.target"];
          wants = ["network-online.target"];
          wantedBy = ["multi-user.target"];

          script = ''
            set -x
            MACS="`ip -j link | jq '.[].address' -r | grep -vE 'null' | grep -vE '00:00:00:00:00:00'`"

            MAC_ARGS=()

            for mac in $MACS
            do
              MAC_ARGS+=(--macaddress $mac)
            done

            ipa host-mod "${config.networking.fqdn}" \
              --sshpubkey="$(cat /etc/ssh/ssh_host_ed25519_key.pub)" \
              --sshpubkey="$(cat /etc/ssh/ssh_host_rsa_key.pub)" \
              --updatedns "''${MAC_ARGS[@]}" || true
          '';
        };

        # sssd = {
        #   before = ["nfs-idmapd.service" "rpc-gssd.service" "rpc-svcgssd.service"];

        #   # environment = {
        #   #   LDB_MODULES_PATH = "/run/current-system/sw/modules/ldb";
        #   # };

        #   # script = lib.mkForce "echo $LDB_MODULES_PATH && ${pkgs.sssd}/bin/sssd -D";
        #   # serviceConfig = {
        #   #   Type = lib.mkForce "notify";
        #   #   NotifyAccess = "main";
        #   # };
        #   # -c ${settingsFile}
        # };
        sssd-kcm = {
          #   enable = true;
          #   description = "SSSD Kerberos Cache Manager";

          #   wantedBy = ["multi-user.target" "sssd.service"];
          #   requires = ["sssd-kcm.socket"];

          serviceConfig = {
            #   ExecStartPre = lib.mkForce null;
            ExecStart = lib.mkForce "${pkgs.sssd}/libexec/sssd/sssd_kcm";
          };
          #   # restartTriggers = [
          #   #   settingsFileUnsubstituted
          #   # ];
        };
      };
      # sockets.sssd-kcm = {
      # enable = true;
      # description = "SSSD Kerberos Cache Manager responder socket";
      # wantedBy = ["sockets.target"];
      # Matches the default in MIT krb5 and Heimdal:
      # https://github.com/krb5/krb5/blob/krb5-1.19.3-final/src/include/kcm.h#L43
      # listenStreams = ["/var/run/.heim_org.h5l.kcm-socket"];
      # };
    };

    security = {
      sudo.package = pkgs.sudo.override {withSssd = true;};

      pki.certificateFiles = [config.security.ipa.certificate];
    };

    # programs.ssh.extraConfig = ''
    #   ProxyCommand ${pkgs.sssd}/bin/sss_ssh_knownhostsproxy -p %p %h
    #   GlobalKnownHostsFile /var/lib/sss/pubconf/known_hosts
    # '';

    services = {
      dbus = {
        enable = true;
        packages = [pkgs.realmd];
      };

      udev.extraRules = ''
        SUBSYSTEM=="hidraw", ENV{ID_SECURITY_TOKEN}=="1", RUN{program}+="${pkgs.acl}/bin/setfacl -m u:sssd:rw $env{DEVNAME}"
      '';
      # nscd = {
      #   enableNsncd = true;
      #   config = ''
      #     enable-cache hosts yes
      #     enable-cache passwd no
      #     enable-cache group no
      #     enable-cache netgroup no
      #   '';
      # };
      # };

      sssd = {
        enable = true;
        kcm = true;
        sshAuthorizedKeysIntegration = true;
        # config = lib.mkAfter ''
        #   [domain/harkema.io]
        #   ldap_id_mapping = True
        #   debug_level = 7

        #   [sssd]
        #   debug_level = 7

        #   [pam]
        #   debug_level = 7
        # '';
        # config = lib.mkAfter ''
        #   [sssd]
        #   debug_level = 10

        #   [pam]
        #   debug_level = 10
        # '';
      };
    };

    systemd.tmpfiles.settings."10-zsh" = {
      "/usr/bin/zsh"."L+" = {
        argument = "${pkgs.zsh}/bin/zsh";
      };
    };

    system.nssDatabases = {
      sudoers = ["sss"];
    };
    networking.domain = "harkema.io";

    security = {
      ipa = {
        enable = true;
        server = "ipa.harkema.io";
        domain = "harkema.io";
        realm = "HARKEMA.IO";
        basedn = "dc=harkema,dc=io";
        certificate = pkgs.fetchurl {
          url = "https://ipa.harkema.io/ipa/config/ca.crt";
          sha256 = "0knh6zfvyww08x9s5h1xyw564pckmc75zh6pnh9f1x3c114nkl90";
        };
        # certificate = "${./ca.crt}";
        dyndns.enable = true;
        ifpAllowedUids = [
          "root"
          "tomas"

          #"1000" "1002" "gdm" "132"
        ];
        cacheCredentials = true;
        offlinePasswords = true;
      };

      krb5 = {
        settings.libdefaults.default_ccache_name = "KEYRING:persistent:%{uid}";
      };

      polkit = {
        enable = true;
        extraConfig = ''
          polkit.addRule(function(action, subject) {
            if (action.id == "org.freedesktop.policykit.exec" && subject.isInGroup("admins")) {
              return polkit.Result.YES;
            }
          });
          polkit.addAdminRule(function(action, subject) {
            return ["unix-group:admins", "unix-group:wheel"];
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
