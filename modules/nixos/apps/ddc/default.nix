{
  config,
  lib,
  pkgs,
  ...
}: let
  cfg = config.apps.ddc;
in {
  options.apps.ddc = {
    enable = lib.mkEnableOption "ddc";
  };

  config = lib.mkIf (cfg.enable && false) {
    services = {
      ddccontrol.enable = true;
      udev.extraRules = ''
        SUBSYSTEM=="i2c-dev", ACTION=="add",\
          ATTR{name}=="NVIDIA i2c adapter*",\
          TAG+="ddcci",\
          TAG+="systemd",\
          ENV{SYSTEMD_WANTS}+="ddcci@$kernel.service"

        KERNEL=="i2c-[0-9]*", GROUP="i2c", MODE="0660"
      '';
    };

    systemd.services = {
      ddccontrol = {path = with pkgs; [kmod gnugrep];};

      "ddcci@" = {
        scriptArgs = "%i";
        script = ''
          echo Trying to attach ddcci to $1
          i=0
          id=$(echo $1 | cut -d "-" -f 2)
          if ${pkgs.ddcutil}/bin/ddcutil getvcp 10 -b $id; then
            echo ddcci 0x37 > /sys/bus/i2c/devices/$1/new_device
          fi
        '';
        serviceConfig.Type = "oneshot";
      };
    };
  };
}
