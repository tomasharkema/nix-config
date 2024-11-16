{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.services.abrt;
  package = pkgs.abrt;
in {
  options.services.abrt = {
    enable = (lib.mkEnableOption "abrt") // {default = true;};

    server.enable = lib.mkEnableOption "abrt server";
    client.enable =
      (lib.mkEnableOption "abrt client")
      // {
        default = !(cfg.server.enable);
      };
  };

  config = lib.mkIf cfg.enable {
    age.secrets."abrt-key" = {
      rekeyFile = ./abrt-key.age;
      generator.script = "ssh-ed25519";
    };

    users = {
      groups = {
        abrt = {gid = 173;};
        abrt-upload = {};
      };

      users = {
        abrt = {
          uid = 173;
          isSystemUser = true;
          group = "abrt";
          extraGroups = ["systemd-journal"];
          home = "/etc/abrt";
        };
        abrt-upload = lib.mkIf cfg.server.enable {
          # isSystemUser = true;
          isNormalUser = true;
          group = "abrt-upload";
          extraGroups = ["abrt"];
          openssh.authorizedKeys.keys = [
            "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICSjyt7NDFLredZCrd4q6A8KUILIqf7eFMXIPvRzYtxI tomas@voltron"
          ];
        };
      };
    };

    environment = {
      variables = {
        AUGEAS_LENS_LIB = "${package}/share/augeas/lenses:/run/current-system/sw/share/augeas/lenses:/run/current-system/sw/share/augeas/lenses/dist";
      };
      sessionVariables = {
        AUGEAS_LENS_LIB = "${package}/share/augeas/lenses:/run/current-system/sw/share/augeas/lenses:/run/current-system/sw/share/augeas/lenses/dist";
      };

      systemPackages = [
        package
        pkgs.augeas
        pkgs.libreport
        pkgs.custom.will-crash
      ];

      etc = {
        "abrt/abrt.conf" = {
          mode = "0600";
          text = ''
            ${lib.optionalString cfg.server.enable "WatchCrashdumpArchiveDir = /var/spool/abrt-upload"}
            ${lib.optionalString config.gui.desktop.enable "ShortenedReporting = yes"}
            DumpLocation = /var/spool/abrt
            ProcessUnpackaged = yes
            AutoreportingEnabled = yes
            OpenGPGCheck = no
            DebugLevel = 100
          '';
        };
        "abrt/plugins/oops.conf".text = '''';
        "abrt/plugins/CCpp.conf".text = '''';
        "abrt/plugins/xorg.conf".text = '''';
        "abrt/plugins/vmcore.conf".text = '''';
        "abrt/abrt-action-save-package-data.conf".text = '''';
        "abrt/gpg_keys.conf".text = '''';
        "libreport/libreport.conf".text = "";
        "libreport/plugins/mailx.conf".text = ''

        '';
        "libreport/plugins/upload.conf" = {
          mode = "0600";
          text = ''
            URL = scp://root@silver-star-vm/var/spool/abrt-upload/
            SSHPrivateKey = ${config.age.secrets."abrt-key".path}
          '';
        };
        "libreport/events.d/uploader_event.conf" = {
          mode = "0600";
          text = ''
            EVENT=notify reporter-upload
          '';
        };
        "libreport/events.d/ntfy.conf" = {
          mode = "0600";

          text = ''
            EVENT=notify ${pkgs.ntfy-sh}/bin/ntfy publish --title "$HOSTNAME Crash $(cat executable)" "$(cat ${config.age.secrets.ntfy.path})" "$(cat executable)"
          '';
        };
        "libreport/report_event.conf".source = "${package}/etc/libreport/report_event.conf";

        "profile.d/abrt-console-notification.sh".source = "${package}/etc/profile.d/abrt-console-notification.sh";
        "libreport/events.d/abrt_dbus_event.conf".source = "${package}/etc/libreport/events.d/abrt_dbus_event.conf";
        "libreport/events.d/bodhi_event.conf".source = "${package}/etc/libreport/events.d/bodhi_event.conf";
        "libreport/events.d/gconf_event.conf".source = "${package}/etc/libreport/events.d/gconf_event.conf";
        "libreport/events.d/machine-id_event.conf".source = "${package}/etc/libreport/events.d/machine-id_event.conf";
        "libreport/events.d/smart_event.conf".source = "${package}/etc/libreport/events.d/smart_event.conf";
        "libreport/events.d/vmcore_event.conf".source = "${package}/etc/libreport/events.d/vmcore_event.conf";
        "libreport/events.d/abrt_event.conf".source = "${package}/etc/libreport/events.d/abrt_event.conf";
        "libreport/events.d/ccpp_event.conf".source = "${package}/etc/libreport/events.d/ccpp_event.conf";
        "libreport/events.d/koops_event.conf".source = "${package}/etc/libreport/events.d/koops_event.conf";
        "libreport/events.d/python3_event.conf".source = "${package}/etc/libreport/events.d/python3_event.conf";
        "libreport/events.d/vimrc_event.conf".source = "${package}/etc/libreport/events.d/vimrc_event.conf";
        "libreport/events.d/xorg_event.conf".source = "${package}/etc/libreport/events.d/xorg_event.conf";
      };
    };

    system.activationScripts."system-release" = ''
      echo $(uname -mrs) > /etc/system-release
    '';

    systemd = {
      # packages = [pkgs.abrt];

      tmpfiles.packages = [pkgs.abrt];

      # tmpfiles.settings."10-abrt" = {
      #   "/var/lib/abrt".d = {
      #     user = "abrt";
      #     group = "abrt";
      #     mode = "0755";
      #   };
      #   "/var/spool/abrt-upload".d = {
      #     user = "abrt";
      #     group = "abrt";
      #     mode = "0755";
      #   };
      # };

      services = {
        abrt-dump-journal-core = {
          path = [package pkgs.libreport];
          description = "ABRT coredumpctl message creator";
          after = ["abrtd.service"];
          requisite = ["abrtd.service"];

          wantedBy = ["multi-user.target"];

          serviceConfig = {
            Type = "simple";
            ExecStart = "${package}/bin/abrt-dump-journal-core -D -T -f -e";
          };
        };

        abrt-dump-journal-oop = {
          path = [package pkgs.libreport];
          description = "ABRT kernel log watcher";
          after = ["abrtd.service"];
          requisite = ["abrtd.service"];
          wantedBy = ["multi-user.target"];
          serviceConfig = {
            ExecStart = "${package}/bin/abrt-dump-journal-oops -fxtD";
          };
        };

        abrt-pstoreoops = {
          path = [package pkgs.libreport];
          description = "ABRT kernel oops pstore collector";
          after = ["abrtd.service"];
          requisite = ["abrtd.service"];
          wantedBy = ["multi-user.target"];

          unitConfig = {
            ConditionDirectoryNotEmpty = "/sys/fs/pstore";
          };

          serviceConfig = {
            Type = "oneshot";
            ExecStart = "${package}/sbin/abrt-harvest-pstoreoops";
            RemainAfterExit = "yes";
          };
        };

        abrt-upload-watch = lib.mkIf cfg.server.enable {
          path = [package pkgs.libreport];
          description = "ABRT upload watcher";
          after = ["abrtd.service"];
          requisite = ["abrtd.service"];
          wantedBy = ["multi-user.target"];
          serviceConfig = {
            ExecStart = "${package}/sbin/abrt-upload-watch";
          };
        };

        abrt-vmcore = {
          path = [package pkgs.libreport];
          description = "ABRT kernel panic detection";
          after = ["abrtd.service"];
          requisite = ["abrtd.service"];
          wantedBy = ["multi-user.target"];

          unitConfig = {
            ConditionDirectoryNotEmpty = "/var/crash";
          };

          serviceConfig = {
            Type = "oneshot";
            ExecStart = "${package}/sbin/abrt-harvest-vmcore";
            RemainAfterExit = "yes";
          };
        };

        abrt-xorg = lib.mkIf config.gui.desktop.enable {
          path = [package pkgs.libreport];
          description = "ABRT Xorg log watcher";
          after = ["abrtd.service"];
          requisite = ["abrtd.service"];
          wantedBy = ["multi-user.target"];
          serviceConfig = {
            ExecStart = "${package}/bin/abrt-dump-journal-xorg -fxtD";
          };
        };

        abrtd = {
          path = [package pkgs.libreport];
          wantedBy = ["multi-user.target"];
          description = "abrtd";
          serviceConfig = {
            ExecStartPre = [
              "-${pkgs.coreutils}/bin/mkdir -p /var/lib/abrt"
              "-${pkgs.coreutils}/bin/mkdir -p /var/run/abrt"
              "-${pkgs.coreutils}/bin/mkdir -p /var/cache/abrt-di"
              "-${pkgs.coreutils}/bin/mkdir -p /var/spool/abrt-upload"

              "${pkgs.bash}/bin/bash -c \"${pkgs.procps}/bin/pkill abrt-dbus || :\""
            ];
            ExecStart = "${package}/bin/abrtd -d -s -vvv";

            Type = "dbus";
            BusName = "org.freedesktop.problems.daemon";
            DevicePolicy = "closed";
            KeyringMode = "private";
            LockPersonality = "yes";
            MemoryDenyWriteExecute = "yes";
            NoNewPrivileges = "yes";
            PrivateDevices = "yes";
            PrivateTmp = true;
            ProtectClock = "yes";
            ProtectControlGroups = "yes";
            ProtectHome = "read-only";
            ProtectHostname = "yes";
            ProtectKernelLogs = "yes";
            ProtectKernelModules = "yes";
            ProtectKernelTunables = "yes";
            ProtectProc = "invisible";
            ProtectSystem = "full";
            RestrictNamespaces = "yes";
            RestrictRealtime = "yes";
            RestrictSUIDSGID = "yes";
            SystemCallArchitectures = "native";
          };
        };
      };
    };
    services.dbus = {
      enable = true;
      packages = [package];
    };
    security.polkit = {
      enable = true;
    };
  };
}
