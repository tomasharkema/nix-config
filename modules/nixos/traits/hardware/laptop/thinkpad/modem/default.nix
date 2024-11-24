{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.traits.hardware.laptop.thinkpad;
  settingsFile = pkgs.writeText "xmm7360.ini" ''
    # driver config
    apn=multimedia.lebara.nl

    #ip-fetch-timeout=1
    nodefaultroute=True
    #metric=1000

    # uncomment to not add DNS values to /etc/resolv.conf
    #noresolv=True

    # used to activate NetworkManager integration
    dbus=True

    # Setup script config
    BIN_DIR=/run/current-system/sw/bin
  '';
  xmm7360 = pkgs.custom.xmm7360-pci.override {kernel = config.boot.kernelPackages.kernel;};

  mm = pkgs.modemmanager.overrideAttrs (old: {
    patch =
      old.patches
      ++ [
        ./mm-xmm.patch
      ];
  });
in {
  config = lib.mkIf cfg.enable {
    system.build.mm = mm;
    environment = {
      etc = {
        "xmm7360".source = settingsFile;
      };

      systemPackages = with pkgs; [
        mm
        modem-manager-gui
        libmbim
        custom.xmmctl
        xmm7360
        custom.xmm2usb
        libsForQt5.modemmanager-qt
        # chatty
      ];
    };

    programs.nm-applet.enable = true;

    boot = {
      kernelModules = ["acpi_call" "xmm7360"];

      extraModulePackages = [
        xmm7360
        config.boot.kernelPackages.acpi_call
      ];

      blacklistedKernelModules = [
        "iosm"
      ];
    };

    services = {
      udev.packages = [mm];
      dbus.packages = [mm];
    };

    networking.networkmanager.fccUnlockScripts = [];

    systemd = {
      packages = [
        # mm
        # pkgs.custom.lenovo-wwan-unlock
      ];

      services.xmm7360 = {
        description = "XMM7360 Modem Init";
        after = ["NetworkManager.service"];
        requires = ["multi-user.target" "systemd-user-sessions.service" "dev-ttyXMM2.device"];
        wantedBy = ["graphical.target"];

        serviceConfig = {
          Type = "oneshot";
          ExecStart = "${xmm7360}/bin/open_xdatachannel.py -c /etc/xmm7360";
          RemainAfterExit = "yes";
          TimeoutSec = "60";
        };
      };
    };
  };
}
