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
    system.nixos.tags = ["media-center"];
    xdg.portal.enable = mkForce false;
    sound.mediaKeys.enable = true;
    sound.enable = true;
    apps.flatpak.enable = mkForce false;

    services.pipewire = {
      enable = mkForce false;
    };

    gui = {
      gnome.enable = mkForce false;
      quiet-boot.enable = mkForce false;
    };

    services.xserver.enable = true;
    services.xserver.desktopManager.kodi.enable = true;
    services.xserver.displayManager.autoLogin.enable = true;
    services.xserver.displayManager.autoLogin.user = "kodi";

    # This may be needed to force Lightdm into 'autologin' mode.
    # Setting an integer for the amount of time lightdm will wait
    # between attempts to try to autologin again.
    services.xserver.displayManager.lightdm.autoLogin.timeout = 3;

    # Define a user account
    users.extraUsers.kodi.isNormalUser = true;
    # services.xserver = {
    #   enable = true;

    #   windowManager = {
    #     ratpoison.enable = true;
    #   };

    #   displayManager = {
    #     autoLogin = {
    #       enable = true;
    #       user = "media";
    #     };
    #     gdm.enable = mkForce false;
    #     sddm = {
    #       enable = true;
    #     };
    #     # pasuspender -- env AE_SINK=ALSA
    #     sessionCommands = ''
    #       exec ${lib.getExe pkgs.plex-media-player} --fullscreen --tv
    #     '';
    #   };
    # };
    environment.systemPackages = with pkgs; [
      plymouth
    ];

    boot = {
      plymouth = {
        enable = true;
      };
    };
    # users.extraUsers.media = {
    #   isNormalUser = true;
    #   uid = 1100;
    #   extraGroups = ["audio"];
    # };
    networking.firewall = {
      enable = mkForce false;
      allowedTCPPorts = [
        8080
        8060 # the plex frontend does upnp things
        32433 # plex-media-player
      ];
    };
  };
}
