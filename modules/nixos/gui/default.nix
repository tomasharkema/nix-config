{
  lib,
  config,
  inputs,
  pkgs,
  ...
}: let
  cfg = config.gui;
in {
  # imports = [
  #   "${inputs.unstable}/nixos/modules/services/desktops/seatd.nix"
  # ];

  options.gui = {
    enable = lib.mkEnableOption "gui.defaults";

    hidpi.enable = lib.mkEnableOption "enable generic hidpi for desktop";
    hdr.enable = lib.mkEnableOption "enable generic hdr for desktop";
  };

  config = lib.mkIf cfg.enable {
    assertions = [
      {
        assertion = cfg.desktop.enable;
        message = "you can't enable this for that reason";
      }
    ];

    system.build = {
      i2c-ch341-usb = pkgs.custom.i2c-ch341-usb.override {kernel = config.boot.kernelPackages.kernel;};
      ch341-i2c-spi-gpio = pkgs.custom.ch341-i2c-spi-gpio.override {kernel = config.boot.kernelPackages.kernel;};
    };

    gui = {
      gamemode.enable = lib.mkDefault false;
      quiet-boot.enable = lib.mkDefault true;
      desktop.enable = lib.mkDefault true;
      gnome.enable = lib.mkDefault true;
    };

    users.groups = {
      "camera".members = ["root" "tomas"];
    };

    apps.flatpak.enable = lib.mkDefault true;

    services = {
      # tzupdate.enable = true;
      # devmon.enable = true;

      seatd.enable = true;

      printing = {
        enable = true;
        drivers = with pkgs; [
          brlaser
          custom.brother-mfc2710dw-ppd
          ptouch-driver
        ];
        # cups-pdf.enable = true;
      };
      # stirling-pdf.enable = true;

      playerctld.enable = true;

      displayManager.defaultSession = "niri";

      g810-led = {
        enable = true;
        profile = ''
          # G810-LED Profile (turn all keys on)

          # Set all keys on
          a ffffff

          c
        '';
      };
      # automatic-timezoned.enable = true;
      udev = {
        packages = with pkgs; [
          imsprog
          picoprobe-udev-rules
          nrf-udev
          game-devices-udev-rules
          logitech-udev-rules
          platformio-core
          openocd
          solaar
          picotool
        ];
        extraRules = ''
          SUBSYSTEM=="usb", \
              ATTRS{idVendor}=="2e8a", \
              ATTRS{idProduct}=="0003", \
              TAG+="uaccess", \
              MODE="660", \
              GROUP="plugdev"
          SUBSYSTEM=="usb", \
              ATTRS{idVendor}=="2e8a", \
              ATTRS{idProduct}=="0009", \
              TAG+="uaccess", \
              MODE="660", \
              GROUP="plugdev"
          SUBSYSTEM=="usb", \
              ATTRS{idVendor}=="2e8a", \
              ATTRS{idProduct}=="000a", \
              TAG+="uaccess", \
              MODE="660", \
              GROUP="plugdev"
          SUBSYSTEM=="usb", \
              ATTRS{idVendor}=="2e8a", \
              ATTRS{idProduct}=="000f", \
              TAG+="uaccess", \
              MODE="660", \
              GROUP="plugdev"
        '';
      };
    };

    hardware = {
      sensor.iio.enable = true;
      usbStorage.manageShutdown = true;
      flipperzero.enable = true;
      logitech = {
        # enable = true;
        # enableGraphical = true;
        wireless = {
          enable = true;
          enableGraphical = true;
        };
      };
    };

    programs = {
      gphoto2.enable = true;
      # nm-applet.enable = true;
    };

    systemd.packages = with pkgs; [
      udev-block-notify
    ];

    # systemd = {enableEmergencyMode = lib.mkDefault true;};

    boot = {
      kernelParams = [
        "preempt=lazy"
        "delayacct"
      ];

      binfmt.emulatedSystems = [
        "wasm32-wasi"
        "x86_64-windows"
        "aarch64-linux"
      ];

      # kernelModules = [
      # "wacom"
      # "spi_ch341"
      # "spidev"
      #"i2c-ch341-usb"
      # ];
      # blacklistedKernelModules = ["ch341"];

      extraModulePackages = [
        # config.system.build.input-wacom
        # config.system.build.i2c-ch341-usb
        # config.system.build.ch341-i2c-spi-gpio
      ];
    };
  };
}
