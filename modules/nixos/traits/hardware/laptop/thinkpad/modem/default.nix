{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.traits.hardware.laptop.thinkpad;
  settingsFile = pkgs.writeText "xmm7360.ini" ''
    # driver config
    apn=internet

    #ip-fetch-timeout=1
    nodefaultroute=True
    metric=1005

    # uncomment to not add DNS values to /etc/resolv.conf
    #noresolv=True

    # used to activate NetworkManager integration
    dbus=True

    # Setup script config
    BIN_DIR=/run/current-system/sw/bin
  '';
  xmm7360 = pkgs.custom.xmm7360-pci.override {kernel = config.boot.kernelPackages.kernel;};
  xmm7360-spat = pkgs.custom.xmm7360-pci-spat.override {kernel = config.boot.kernelPackages.kernel;};
  xmm7360-lts = pkgs.custom.xmm7360-pci.override {kernel = pkgs.linuxPackages.kernel;};
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

  _libqmi = let
    version = "1.37.95-dev";
  in
    pkgs.libqmi.overrideAttrs ({buildInputs ? [], ...}: {
      pname = "libqmi";
      inherit version;

      src = pkgs.fetchFromGitLab {
        domain = "gitlab.freedesktop.org";
        owner = "mobile-broadband";
        repo = "libqmi";
        rev = version;
        hash = "sha256-ZMJx1OTWCPy63Nl50lzgZCAfutAUSHq+iFWCe300kG8=";
      };
      buildInputs =
        buildInputs
        ++ [
          pkgs.gi-docgen
        ];
      outputs = ["out" "dev"];
    });

  # _libmbim = prev.libmbim.overrideAttrs (old: rec {
  #   pname = "libmbim";
  #   version = "1.31.5-dev";

  #   src = prev.fetchFromGitLab {
  #     domain = "gitlab.freedesktop.org";
  #     owner = "mobile-broadband";
  #     repo = "libmbim";
  #     rev = version;
  #     hash = "sha256-Brut0PobAc6rTbGAo4NTauzHtwJrZOJjEw26hyXqA5w="; # "sha256-sHTpu9WeMZroT+1I18ObEHWSzcyj/Relyz8UNe+WawI=";
  #   };
  # });
  _modemmanager = let
    version = "1.25.95-dev";
  in
    pkgs.modemmanager.overrideAttrs (oldAttrs: {
      pname = "modemmanager";
      version = version;

      libqmi = _libqmi;

      src = pkgs.fetchFromGitLab {
        domain = "gitlab.freedesktop.org";
        owner = "mobile-broadband";
        repo = "ModemManager";
        rev = version;
        hash = "sha256-xyb9LTkuJyTqt0yWDDJTYiICFVFJ5SqRlnOdrhrL2Ps=";
      };
      # patches =
      #   oldAttrs.patches
      #   ++ [
      #     (prev.fetchpatch {
      #       url = "https://gitlab.freedesktop.org/mobile-broadband/ModemManager/-/merge_requests/1200.patch";
      #       hash = "sha256-7z3YMNbrU1E55FgmOaTFbsK2qXCBnbRkDrS+Yogxgow=";
      #     })
      #   ];
    });
in {
  config = lib.mkIf cfg.enable {
    system.build = {
      xmm7360 = xmm7360;
      xmm7360-spat = xmm7360-spat;
      xmm7360-lts = xmm7360-lts;
    };

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

    networking.modemmanager = {
      enable = true;
      # package = _modemmanager;
    };
    boot = {
      kernelModules = [
        # "acpi_call"
        # "xmm7360"
      ];

      extraModulePackages = [
        xmm7360
      ];

      blacklistedKernelModules = [
        "iosm"
      ];
    };

    hardware = {
      # usb-modeswitch.enable = true;
      # usbWwan.enable = true;
    };

    systemd.services.xmm7360 = {
      # enable = false;
      description = "XMM7360 Modem Init";
      after = ["NetworkManager.service"];
      requires = [
        "multi-user.target"
        "systemd-user-sessions.service"
        # "dev-ttyXMM2.device"
      ];
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
