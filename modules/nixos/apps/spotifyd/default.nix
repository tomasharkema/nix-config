{ lib, pkgs, config, ... }:
with lib;
let cfg = config.apps.spotifyd;
in {
  options.apps.spotifyd = { enable = mkEnableOption "spotifyd"; };

  config = mkIf cfg.enable {
    #   environment.systemPackages = with pkgs; [
    #     # spotify
    #     spotifyd
    #   ];
    users.users = {
      "tomas".extraGroups = [ "audio" ];
      "root".extraGroups = [ "audio" ];
    };

    services = {

      dbus = {
        enable = true;
        packages = [ pkgs.shairport-sync pkgs.spotifyd pkgs.mpv ];
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
            # mpris = true;
            device_name = "${config.networking.hostName} SpotifyD";
            # use_keyring = false;
            # dbus_type = "system";
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
        wantedBy = [ "default.target" ];
      };

      spotifyd = {
        environment = {
          SPOTIFYD_CLIENT_ID = "be2bcefc4eeb43b8b13b4a0e05e572a4";
          SPOTIFYD_REDIRECT_URI = "http://localhost:8888/callback";
          SPOTIFYD_CLIENT_SECRET = "6d079368a5e64e3bb6a9d232aa043789";
        };
      };
    };

    networking.firewall = {
      allowedUDPPorts = [ 33677 ];
      allowedTCPPorts = [ 33677 ];
    };
    # };
  };
}
