{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.gui.quiet-boot;
in {
  options.gui.quiet-boot = {enable = lib.mkEnableOption "quiet-boot enabled";};

  config = lib.mkIf (cfg.enable) {
    console = {
      earlySetup = lib.mkForce false;
      packages = [pkgs.terminus_font];
    };

    environment.systemPackages = with pkgs; [plymouth];

    boot = {
      plymouth = {
        enable = true;

        font = "${pkgs.inter}/share/fonts/truetype/InterVariable.ttf";
      };

      loader.timeout = 0;
      kernelParams = [
        "quiet"
        "loglevel=3"
        "systemd.show_status=false"
        "rd.systemd.show_status=false"
        "udev.log_level=3"
        "rd.udev.log_level=3"
        "vga=current"
        "splash"
        "vt.global_cursor_default=0"

        "boot.shell_on_fail"
      ];
      consoleLogLevel = 0;
      initrd = {
        systemd.enable = true;
        verbose = false;
      };
    };

    systemd.services = let
      script = pkgs.writeScript "plymouth-messages" ''
        sleep 1
        journalctl --quiet -f -n0 --system -t systemd -o cat | while read -r line; do
        	plymouth display-message --text="$line"
          if [ $? -ne 0 ]; then
        		break
        	fi
        done
        echo "Plymouth died, exiting..."
      '';
    in {
      "plymouth-boot-messages" = {
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

        script = "${script}";
      };
      "plymouth-poweroff-messages" = {
        path = with pkgs; [
          systemd
          plymouth
        ];

        wantedBy = ["poweroff.target" "halt.target" "shutdown.target"];
        after = ["plymouth-poweroff.service"];
        before = ["poweroff.target" "halt.target" "shutdown.target"];
        requires = ["plymouth-poweroff.service"];

        unitConfig = {
          Description = "Display boot messages on the plymouth screen";
          DefaultDependencies = "no";
        };

        serviceConfig = {
          Type = "simple";
        };

        script = "${script}";
      };
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
