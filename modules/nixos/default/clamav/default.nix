{
  pkgs,
  config,
  lib,
  ...
}: {
  options.apps.clamav.onacc = {enable = lib.mkEnableOption "onacc" // {default = true;};};

  config = lib.mkIf false {
    environment.systemPackages = with pkgs; [
      clamtk
    ];

    # ALERT="Signature detected by clamav: $CLAM_VIRUSEVENT_VIRUSNAME in $CLAM_VIRUSEVENT_FILENAME"

    # # Send an alert to all graphical users.
    # for ADDRESS in /run/user/*; do
    #     USERID=${ADDRESS#/run/user/}
    #     /usr/bin/sudo -u "#$USERID" DBUS_SESSION_BUS_ADDRESS="unix:path=$ADDRESS/bus" PATH=${PATH} \
    #         /usr/bin/notify-send -w -u critical -i dialog-warning "Virus found!" "$ALERT"
    # done

    services = {
      logrotate = {
        enable = true;

        settings = {
          "/var/log/clamav/*.log" = {
            frequency = "daily";
            rotate = 3;
          };
        };
      };

      clamav = {
        daemon = {
          enable = true;
          settings = {
            LogSyslog = true;
            OnAccessExcludeRootUID = true;
            OnAccessExcludeUname = "clamav";
            # OnAccessMountPath = ["/"];
            OnAccessIncludePath = ["/home"];
            OnAccessExtraScanning = true;
            OnAccessExcludePath = [
              "^/var/lib"
              "^/srv"
              "^/nix"
            ];
          };
        };

        # scanner.enable = true;
        fangfrisch.enable = true;

        updater.enable = true;
      };
    };

    systemd.services = {
      # clamav-daemon.serviceConfig.Nice = "-15";

      clamav-clamonacc = let
        cfg = config.services.clamav;
      in
        lib.mkIf config.apps.clamav.onacc.enable {
          description = "ClamAV On-Access Scanner";
          after = ["clamav-daemon.service"];
          requires = ["clamav-daemon.service"];
          wantedBy = ["multi-user.target"];
          # wants = lib.optionals cfg.updater.enable ["clamav-freshclam.service"];

          serviceConfig = {
            Type = "simple";
            ExecStartPre = "${pkgs.bash}/bin/bash -c \"while [ ! -S /run/clamav/clamd.ctl ]; do sleep 1; done\"";
            ExecStart = "${cfg.package}/sbin/clamonacc -F --log=/var/log/clamav/clamonacc.log --move=/root/quarantine";
            ExecStop = "kill -SIGKILL $MAINPID";

            # User = "clamav";
            # Group = "clamav";
            # StateDirectory = "clamav";
            # RuntimeDirectory = "clamav";
            # PrivateTmp = "yes";
            # PrivateDevices = "yes";
            # PrivateNetwork = "yes";
            Slice = "system-clamav.slice";
          };
        };
    };
  };
}
