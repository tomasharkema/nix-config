{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: let
  cfg = config.apps.ipa;

  chromePolicy = pkgs.writers.writeJSON "harkema.json" {
    AuthServerWhitelist = "*.harkema.io";
    AuthServerAllowlist = "*.harkema.io";
  };
in {
  options = {
    apps.ipa = {
      enable = lib.mkEnableOption "enable ipa" // {default = true;};
    };
    # services.intune.enable = mkEnableOption "intune";
  };

  config = lib.mkIf (cfg.enable) {
    environment = {
      systemPackages = with pkgs; [
        # ldapvi
        ldapmonitor
        pkcs11helper
        realmd

        (pkgs.writeShellScriptBin "setup-browser-eid" ''
          NSSDB="''${HOME}/.pki/nssdb"
          mkdir -p ''${NSSDB}

          ${pkgs.nssTools}/bin/modutil -force -dbdir sql:$NSSDB -add p11-kit-proxy \
            -libfile ${pkgs.p11-kit}/lib/p11-kit-proxy.so
        '')
      ];

      etc = {
        "pkcs11/modules/opensc-pkcs11".text = ''
          module: ${pkgs.opensc}/lib/opensc-pkcs11.so
        '';
        "pkcs11/modules/libykcs11".text = ''
          module: ${pkgs.yubico-piv-tool}/lib/libykcs11.so
        '';

        "krb5.conf".text = lib.mkBefore ''
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

        "nsswitch.conf".text = ''
          sudoers:   ${lib.concatStringsSep " " ["sss"]}
          netgroup:  ${lib.concatStringsSep " " ["sss"]}
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
            debug_level = 6
          '';
        };
        # "chromium/native-messaging-hosts/eu.webeid.json".source = "${pkgs.web-eid-app}/share/web-eid/eu.webeid.json";
        # "opt/chrome/native-messaging-hosts/eu.webeid.json".source = "${pkgs.web-eid-app}/share/web-eid/eu.webeid.json";

        "chromium/policies/managed/harkema.json".source = chromePolicy;
        "opt/chrome/policies/managed/harkema.json".source = chromePolicy;
      };
    };

    programs.firefox = {
      nativeMessagingHosts.euwebid = true;
      policies.SecurityDevices.p11-kit-proxy = "${pkgs.p11-kit}/lib/p11-kit-proxy.so";
    };

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

        sssd = {
          before = ["nfs-idmapd.service" "rpc-gssd.service" "rpc-svcgssd.service"];

          environment = {
            LDB_MODULES_PATH = "${pkgs.sssd}/modules/ldb";
          };
        };
        sssd-kcm = {
          # enable = true;
          # description = "SSSD Kerberos Cache Manager";

          # wantedBy = ["multi-user.target" "sssd.service"];
          # requires = ["sssd-kcm.socket"];

          serviceConfig = {
            # ExecStartPre = "-${pkgs.sssd}/bin/sssd --genconf-section=kcm";
            ExecStart = lib.mkForce "${pkgs.sssd}/libexec/sssd/sssd_kcm";
          };
          # restartTriggers = [
          #   settingsFileUnsubstituted
          # ];
        };
      };
      # sockets.sssd-kcm = {
      #   enable = true;
      #   description = "SSSD Kerberos Cache Manager responder socket";
      #   wantedBy = ["sockets.target"];
      #   # Matches the default in MIT krb5 and Heimdal:
      #   # https://github.com/krb5/krb5/blob/krb5-1.19.3-final/src/include/kcm.h#L43
      #   listenStreams = ["/var/run/.heim_org.h5l.kcm-socket"];
      # };
    };

    security = {
      sudo.package = pkgs.sudo.override {withSssd = true;};
      krb5.settings.libdefaults.default_ccache_name = "KCM:";

      pki.certificateFiles = [config.security.ipa.certificate];
    };

    services.udev.extraRules = ''
      SUBSYSTEM=="hidraw", ENV{ID_SECURITY_TOKEN}=="1", RUN{program}+="${pkgs.acl}/bin/setfacl -m u:sssd:rw $env{DEVNAME}"
    '';

    # programs.ssh.extraConfig = ''
    #   ProxyCommand ${pkgs.sssd}/bin/sss_ssh_knownhostsproxy -p %p %h
    #   GlobalKnownHostsFile /var/lib/sss/pubconf/known_hosts
    # '';

    services = {
      dbus = {
        enable = true;
        packages = [pkgs.realmd];
      };

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

        # [sssd]
        # debug_level 0x1310
      };
    };

    systemd.tmpfiles.settings."10-zsh" = {
      "/bin/zsh"."L+" = {
        argument = "${pkgs.zsh}/bin/zsh";
      };
    };

    system.nssDatabases.sudoers = ["sss"];

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
          sha256 = "0x8nsnb0v1q8n4bs8nyhxp5hg0jg5qy8fg9k7vk0w3ph49sb3g38";
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

      # sudo.package = (pkgs.sudo.override { withSssd = true; });

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
