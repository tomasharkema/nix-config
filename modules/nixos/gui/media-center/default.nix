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
    gui.quiet-boot.enable = mkForce false;

    specialisation = {
      media-center = {
        #inheritParentConfig = false;
        configuration = {
          system.nixos.tags = ["media-center"];
          xdg.portal.enable = mkForce false;

          documentation.man.enable = false;

          apps.flatpak.enable = mkForce false;

          gui = {
            gnome.enable = mkForce false;
            quiet-boot.enable = mkForce false;
          };

          services.xserver = {
            enable = true;

            windowManager = {
              ratpoison.enable = true;
              # gnome.enable = false;
            };

            displayManager = {
              autoLogin = {
                enable = true;
                user = "media";
              };
              gdm.enable = mkForce false;
              sddm = {
                enable = true;
              };
              sessionCommands = ''
                exec ${lib.getExe pkgs.plex-media-player} --fullscreen --tv > ~/.plexlogs
              '';
            };
          };

          environment.systemPackages = with pkgs; [
            plex-media-player
            ratpoison
            pavucontrol
            syncplay
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
