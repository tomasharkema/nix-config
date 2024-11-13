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
    enable = lib.mkEnableOption "abrt";
  };

  config = lib.mkIf cfg.enable {
    users = {
      groups.abrt = {};
      users.abrt = {
        isSystemUser = true;
        group = "abrt";
      };
    };

    environment = {
      systemPackages = [package pkgs.augeas];
      etc = {
        "abrt/abrt.conf".text = ''
          WatchCrashdumpArchiveDir = /var/spool/abrt-upload
          DumpLocation = /var/spool/abrt
          ProcessUnpackaged = yes
        '';
        "abrt/plugins/oops.conf".text = '''';
        "abrt/plugins/CCpp.conf".text = '''';
        "abrt/plugins/xorg.conf".text = '''';
        "abrt/plugins/vmcore.conf".text = '''';
        "abrt/abrt-action-save-package-data.conf".text = '''';
        "abrt/gpg_keys.conf".text = '''';
        "libreport/plugins/mailx.conf".text = ''

        '';
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
    systemd = {
      # packages = [pkgs.abrt];

      tmpfiles.settings."10-abrt" = {
        "/var/lib/abrt".d = {
          user = "abrt";
          group = "abrt";
          mode = "0755";
        };
        "/var/spool/abrt-upload".d = {
          user = "abrt";
          group = "abrt";
          mode = "0755";
        };
      };

      services = {
        abrt-dump-journal-core = {
          path = [package];
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
          path = [package];
          description = "ABRT kernel log watcher";
          after = ["abrtd.service"];
          requisite = ["abrtd.service"];
          wantedBy = ["multi-user.target"];
          serviceConfig = {
            ExecStart = "${package}/bin/abrt-dump-journal-oops -fxtD";
          };
        };

        abrt-pstoreoops = {
          path = [package];
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

        abrt-upload-watch = {
          path = [package];
          description = "ABRT upload watcher";
          after = ["abrtd.service"];
          requisite = ["abrtd.service"];
          wantedBy = ["multi-user.target"];
          serviceConfig = {
            ExecStart = "${package}/sbin/abrt-upload-watch";
          };
        };

        abrt-vmcore = {
          path = [package];
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
          path = [package];
          description = "ABRT Xorg log watcher";
          after = ["abrtd.service"];
          requisite = ["abrtd.service"];
          wantedBy = ["multi-user.target"];
          serviceConfig = {
            ExecStart = "${package}/bin/abrt-dump-journal-xorg -fxtD";
          };
        };

        abrtd = {
          path = [package];
          wantedBy = ["multi-user.target"];
          serviceConfig = {
            ExecStartPre = "${pkgs.bash}/bin/bash -c \"${pkgs.procps}/bin/pkill ${package}/bin/abrt-dbus || :\"";
            ExecStart = "${package}/bin/abrtd -d -s";

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
