{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.gui."media-center";
in {
  options.gui."media-center" = {
    enable = mkEnableOption "gui.media-center";
  };

  config = mkIf cfg.enable {
    specialisation = {
      media-center = {
        inheritParentConfig = false;
        configuration = {
          system.nixos.tags = ["media-center"];

          services.xserver = {
            enable = true;
            displayManager = {
              autoLogin = {
                enable = true;
                user = "media";
              };
              sddm = {
                enable = true;
              };
              sessionCommands = ''
                ratpoison &
                exec plexmediaplayer --fullscreen --tv > ~/.plexlogs
              '';
            };
          };
          hardware.pulseaudio = {
            enable = true;
          };
          environment.systemPackages = with pkgs; [
            plex-media-player
            ratpoison
            pavucontrol
            #syncplay
            mpv
            # teamspeak_client
          ];
          users.extraUsers.media = {
            isNormalUser = true;
            uid = 1100;
            extraGroups = ["audio"];
          };
          networking.firewall.allowedTCPPorts = [
            8060 # the plex frontend does upnp things
            32433 # plex-media-player
          ];
        };
      };
    };
  };
}
