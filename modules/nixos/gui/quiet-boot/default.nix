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
      enable = lib.mkForce false;
      earlySetup = lib.mkForce false;
      # packages = [pkgs.terminus_font];
    };

    environment.systemPackages = with pkgs; [plymouth];

    # services.udev.extraRules = ''
    #   ACTION=="add", SUBSYSTEM=="vtconsole", KERNEL=="vtcon*", RUN="/bin/sh -c :"
    # '';

    boot = {
      plymouth = let
        plymouth-nixos-theme = pkgs.stdenv.mkDerivation {
          pname = "nixos-bgrt";
          version = "1.0";

          src = pkgs.fetchFromGitHub {
            owner = "wuX4an";
            repo = "plymouth-theme-nixos-bgrt";
            rev = "e2dc67eab67eaa3bec42ca3a2f3dc6ef4262bddb";
            hash = "sha256-nZSsi8Krd0K8XY4NW11SQl6Hi7qm+uvWOWW1dTLM900=";
          };

          installPhase = ''
            mkdir -p $out/share/plymouth/themes/nixos-bgrt
            substituteInPlace nixos-bgrt.plymouth \
              --replace "@IMAGES@" "$out/share/plymouth/themes/nixos-bgrt/images"
            cp -r * $out/share/plymouth/themes/nixos-bgrt/
          '';
        };
      in {
        enable = true;
        # theme = "nixos-bgrt";
        # package = pkgs.fetchFromGitHub {
        #   owner = "wuX4an";
        #   repo = "plymouth-theme-nixos-bgrt";
        #   rev = "e2dc67eab67eaa3bec42ca3a2f3dc6ef4262bddb";
        #   hash = "sha256-nZSsi8Krd0K8XY4NW11SQl6Hi7qm+uvWOWW1dTLM900=";
        # };
        # themePackages = [plymouth-nixos-theme];
        # font = "${pkgs.iosevka}/share/fonts/truetype/Iosevka-Regular.ttf";
        font = "${pkgs.inter}/share/fonts/truetype/InterVariable.ttf";
      };

      # kernel.sysctl = {
      #   "kernel.printk" = "3 4 1 3";
      # };

      loader.timeout = 0;
      kernelParams = [
        "quiet"
        "loglevel=0"
        "splash"
        "boot.shell_on_fail"
        "udev.log_priority=0"
        # "rd.systemd.show_status=auto"
        "i915.fastboot=1"
        "systemd.show_status=false"
        "rd.systemd.show_status=false"
        "udev.log_level=0"
        "rd.udev.log_level=0"
        # "vga=current"
        "vt.global_cursor_default=0"
        "systemd.mask=systemd-vconsole-setup.service"
      ];
      kernelModules = [
        "efi_pstore"
        # "ramoops"
      ];
      consoleLogLevel = 0;
      initrd = {
        systemd.enable = true;
        verbose = false;
        # services.udev.rules = ''
        #   ACTION=="add", SUBSYSTEM=="vtconsole", KERNEL=="vtcon*", RUN="/bin/sh -c :"
        # '';
        kernelModules = [
          "efi_pstore"
          "simpledrm"
          # "ramoops"
        ];
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
      greetd.serviceConfig = {
        Type = "idle";
        StandardInput = "tty";
        StandardOutput = "tty";
        StandardError = "journal"; # Without this errors will spam on screen
        # Without these bootlogs will spam on screen
        TTYReset = true;
        TTYVHangup = true;
        TTYVTDisallocate = true;
      };
    };
  };
}
