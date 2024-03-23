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

    users.extraUsers.kodi.isNormalUser = true;
    users.users.kodi.extraGroups = ["data" "video" "audio" "input"];
    services.cage.user = "kodi";
    services.cage.program = "${pkgs.kodi-wayland}/bin/kodi-standalone";
    services.cage.enable = true;

    hardware.opengl = {
      enable = true;
      extraPackages = with pkgs; [libva];
    };

    environment.systemPackages = [
      pkgs.pavucontrol
      (pkgs.kodi-wayland.passthru.withPackages (kodiPkgs:
        with kodiPkgs; [
          inputstreamhelper
          inputstream-adaptive
          inputstream-ffmpegdirect
          inputstream-rtmp
          vfs-libarchive
          vfs-rar
          youtube
        ]))
    ];

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
