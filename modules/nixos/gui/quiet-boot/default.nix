{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.gui.quiet-boot;
in {
  options.gui.quiet-boot = {enable = mkEnableOption "quiet-boot enabled";};

  config = mkIf (cfg.enable) {
    console = {
      earlySetup = true;
    };

    environment.systemPackages = with pkgs; [plymouth];

    boot = {
      plymouth = {
        enable = true;
        # theme = "fedora-branded";
        # themePackages = [
        #   pkgs.custom.plymouth-progress
        # ];

        font = "${pkgs.inter}/share/fonts/truetype/Inter.ttc";
      };
      loader.timeout = mkDefault 0;
      kernelParams = [
        "quiet"
        "loglevel=3"
        "systemd.show_status=auto"
        "udev.log_level=3"
        "rd.udev.log_level=3"
        "vt.global_cursor_default=0"
      ];
      consoleLogLevel = mkDefault 0;
      initrd = {
        systemd.enable = mkDefault true;
        verbose = mkDefault false;
      };
    };

    systemd.services."plymouth-boot-messages" = {
      path = with pkgs; [
        systemd
        plymouth
      ];

      wantedBy = ["sysinit.target"];

      after = ["plymouth-start.service"];
      requires = ["plymouth-start.service"];

      unitConfig = {
        Description = "Display boot messages on the plymouth screen";
        DefaultDependencies = "no";
      };

      serviceConfig = {
        Type = "simple";
        RemainAfterExit = "yes";
      };

      script = ''
        journalctl --quiet -f -n0 --system -t systemd -o cat | while read -r line; do
        	plymouth display-message --text="$line"
          if [ $? -ne 0 ]; then
        		break
        	fi
        done
        echo "Plymouth died, exiting..."
      '';
    };

    # # /etc/systemd/system/plymouth-boot-messages.service
    # # Run "systemctl enable plymouth-boot-messages.service" after creating the file

    # [Unit]
    # Description=Display boot messages on the plymouth screen
    # DefaultDependencies=no

    # # You may want these if your plymouth is not started by initramfs, but I want the script to take effect as soon as possible...
    # #After=plymouth-start.service
    # #Requires=plymouth-start.service

    # [Service]
    # Type=simple
    # ExecStart=/usr/local/bin/journalctl_to_plymouth.sh
    # RemainAfterExit=yes

    # [Install]
    # WantedBy=sysinit.target
  };
}
