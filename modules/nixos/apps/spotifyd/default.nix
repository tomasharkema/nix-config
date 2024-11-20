{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.apps.spotifyd;

  dbusconf = pkgs.writeText "spotifyd.conf" ''
    <allow own_prefix="org.mpris.MediaPlayer2.spotifyd"/>
    <allow send_destination_prefix="org.mpris.MediaPlayer2.spotifyd"/>
  '';

  sp = pkgs.spotifyd.overrideAttrs ({postInstall ? "", ...}: {
    postInstall =
      postInstall
      + ''
        mkdir -p $out/etc/dbus-1/system.d
        cp ${dbusconf} $out/etc/dbus-1/system.d/spotifyd.conf
      '';
  });
in {
  options.apps.spotifyd = {
    enable = lib.mkEnableOption "spotifyd";
  };

  config = lib.mkIf cfg.enable {
    users.users = {
      "tomas".extraGroups = ["audio"];
      "root".extraGroups = ["audio"];
    };

    services = {
      dbus = {
        enable = true;
        packages = [
          pkgs.shairport-sync
          sp
        ];
      };

      shairport-sync = {
        enable = true;
        openFirewall = true;

        arguments = ''
          -v -a "%H Shairport" --statistics -o pipe
        '';

        # user = "media";
        # group = "media";
      };

      spotifyd = {
        enable = true;
        # package = sp;
        # use_mpris = false
        settings = {
          global = {
            backend = "pulseaudio";
            bitrate = 320;
            mpris = true;
            device_name = "${config.networking.hostName} SpotifyD";
            use_keyring = true;
            dbus_type = "system";
            zeroconf_port = 1234;
          };
        };
      };
    };

    systemd.services = {
      "nqptp" = {
        description = "nqptp";
        enable = true;
        serviceConfig = {
          ExecStart = "${pkgs.nqptp}/bin/nqptp";
          #Restart = "always";
        };
        wantedBy = ["default.target"];
      };
    };

    networking.firewall = {
      allowedUDPPorts = [
        33677
        1234
      ];
      allowedTCPPorts = [
        33677
        1234
      ];
    };
    # };
  };
}
