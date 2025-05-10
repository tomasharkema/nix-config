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
  xmm7360-reset = pkgs.writeShellScriptBin "xmm7360-reset" ''

    if [ $UID != 0 ] ; then
      echo "please run as root"
      exit 1
    fi

    ${pkgs.kmod}/bin/rmmod xmm7360
    dd if=/sys/bus/pci/devices/0000:03:00.0/config of=/tmp/xmm_cfg bs=256 count=1 status=none
    ${pkgs.kmod}/bin/modprobe acpi_call
    echo '\_SB.PCI0.RP07.PXSX._RST' | tee /proc/acpi/call
    sleep 1
    dd of=/sys/bus/pci/devices/0000:03:00.0/config if=/tmp/xmm_cfg bs=256 count=1 status=none
  '';
in {
  config = lib.mkIf cfg.enable {
    system.build.xmm7360 = xmm7360;

    environment = {
      etc = {
        "xmm7360".source = settingsFile;
      };

      systemPackages = with pkgs; [
        custom.xmmctl
        config.system.build.xmm7360
        custom.xmm2usb
        xmm7360-reset
      ];
    };

    boot = {
      kernelModules = [
        # "acpi_call"
        "xmm7360"
      ];
      extraModulePackages = [
        xmm7360
      ];

      blacklistedKernelModules = [
        "iosm"
      ];
    };

    systemd.services.xmm7360 = {
      # enable = false;
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
}
