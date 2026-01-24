{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.gui;
in {
  config = lib.mkIf cfg.enable {
    # wodan: analog output
    # front:CARD=PCH,DEV=0
    #     HDA Intel PCH, ALC1220 Analog
    #     Front output / input

    boot = {
      kernelModules = ["snd-seq" "snd-rawmidi"];
      kernel.sysctl = {
        "vm.swappiness" = 10;
        "fs.inotify.max_user_watches" = 524288;
      };
      kernelParams = ["threadirq"];
      # postBootCommands = ''
      #   echo 2048 > /sys/class/rtc/rtc0/max_user_freq
      #   echo 2048 > /proc/sys/dev/hpet/max-user-freq
      #   setpci -v -d *:* latency_timer=b0
      #   setpci -v -s $00:1b.0 latency_timer=ff
      # '';
    };
    users.groups."audio".members = ["root" "tomas"];

    services = {
      pipewire = {
        enable = true;
        alsa.enable = false; # true;
        alsa.support32Bit = false; # true;
        pulse.enable = true;
        jack.enable = false; # true;

        raopOpenFirewall = true;

        wireplumber = {
          enable = true;
          # extraConfig = {
          #   "monitor.bluez.properties" = {
          #     "bluez5.dummy-avrcp-player" = true;
          #   };
          #   bluetoothEnhancements = {
          #     "monitor.bluez.properties" = {
          #       "bluez5.dummy-avrcp-player" = true;
          #       "bluez5.enable-sbc-xq" = true;
          #       "bluez5.enable-msbc" = true;
          #       "bluez5.enable-hw-volume" = true;
          #       "bluez5.roles" = ["hsp_hs" "hsp_ag" "hfp_hf" "hfp_ag"];
          #     };
          #   };
          # };
        };

        extraConfig.pipewire = lib.mkIf false {
          "10-airplay" = {
            "context.modules" = [
              {
                name = "libpipewire-module-raop-discover";

                # increase the buffer size if you get dropouts/glitches
                # args = {
                #   "raop.latency.ms" = 500;
                # };
              }
            ];
          };
        };
      };
    };
  };
}
