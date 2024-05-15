{ pkgs, lib, config, ... }:
with lib;
let cfg = config.gui."media-center";
in {
  options.gui."media-center" = { enable = mkEnableOption "gui.media-center"; };

  config = mkIf cfg.enable {
    system.nixos.tags = [ "media-center" ];
    #    xdg.portal.enable = mkForce false;

    programs.dconf.enable = true;

    sound = {
      enable = false;
      mediaKeys.enable = true;
    };

    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      jack.enable = true;
    };

    services.pipewire.extraConfig.pipewire-pulse."92-tcp" = {
      context.modules = [
        {
          name = "module-native-protocol-tcp";
          args = { };
        }
        {
          name = "module-zeroconf-publish";
          args = { };
        }
      ];
      stream.properties = {
        node.latency = "32/48000";
        resample.quality = 1;
      };
    };

    apps.flatpak.enable = mkForce false;

    gui = {
      gnome.enable = mkForce false;
      quiet-boot.enable = mkForce false;
    };

    # # services.cage.user = "kodi";
    # # services.cage.program = "${pkgs.kodi-wayland}/bin/kodi-standalone";
    # # services.cage.enable = true;

    systemd.targets = {
      sleep.enable = mkForce false;
      suspend.enable = mkForce false;
      hibernate.enable = mkForce false;
      hybrid-sleep.enable = mkForce false;
    };

    hardware = {
      opengl = {
        enable = true;
        extraPackages = with pkgs; [ libva vaapiVdpau libvdpau-va-gl ];
        driSupport = true;
      };

    };

    environment.systemPackages = with pkgs; [
      play-with-mpv
      open-in-mpv
      plex-mpv-shim
      mpv
      mpvc
      celluloid
      pwvucontrol

    ];

    # services.xserver.desktopManager.kodi.package = pkgs.kodi.withPackages (pkgs:
    #   with pkgs; [
    #     inputstreamhelper
    #     inputstream-adaptive
    #     inputstream-ffmpegdirect
    #     inputstream-rtmp
    #     vfs-libarchive
    #     vfs-rar
    #     inputstreamhelper
    #     inputstream-adaptive
    #     inputstream-ffmpegdirect
    #     inputstream-rtmp
    #     vfs-libarchive
    #     vfs-rar
    #     youtube
    #     netflix
    #     sendtokodi
    #   ]);

    services.kmscon = { enable = mkForce false; };

    services.cage = {
      user = "media";
      program = "${lib.getExe pkgs.plex-media-player} --fullscreen --tv";

      enable = mkDefault true;
      extraArguments = [ "-d" "-m" "last" ];
    };

    # boot = {
    #   kernelParams = ["quiet"];
    #   plymouth = {
    #     enable = true;
    #   };
    # };

    users.users.media = {
      isNormalUser = true;
      uid = 1100;
      extraGroups = [ "data" "video" "audio" "input" ];
    };

    home-manager = {
      users.media = {
        home.stateVersion = mkDefault "23.11";
        xdg.enable = true;
      };
    };

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
