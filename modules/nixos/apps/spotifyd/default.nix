{
  lib,
  pkgs,
  config,
  ...
}:
with lib; let
  cfg = config.apps.spotifyd;
in {
  options.apps.spotifyd = {enable = mkEnableOption "spotifyd";};

  config = mkIf cfg.enable {
    users.users = {
      "tomas".extraGroups = ["audio"];
      "root".extraGroups = ["audio"];
    };

    services = {
      dbus = {
        enable = true;
        packages = [pkgs.shairport-sync pkgs.spotifyd];
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
        # use_mpris = false
        settings = {
          global = {
            backend = "pulseaudio";
            bitrate = 320;
            mpris = true;
            device_name = "${config.networking.hostName} SpotifyD";
            # use_keyring = true;
            dbus_type = "system";
          };
        };
        #   username_cmd = "${lib.getExe pkgs._1password} item get bnzrqxggvfbfhgln4uceawfbbq --field username"
        #   password_cmd = "${lib.getExe pkgs._1password} item get bnzrqxggvfbfhgln4uceawfbbq --field password"
      };
    };
    #   # systemd.services.spotifyd = {
    #   # environment = {
    #   #   OP_CONNECT_HOST = "http://silver-star.ling-lizard.ts.net:7080";
    #   #   OP_CONNECT_TOKEN = "${config.age.secrets.op.path}";
    #   # };
    #   # };

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
      allowedUDPPorts = [33677];
      allowedTCPPorts = [33677];
    };
    # };
  };
}
