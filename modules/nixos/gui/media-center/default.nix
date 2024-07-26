{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.gui."media-center";

  kodi = pkgs.kodi-wayland.withPackages (pkgs:
    with pkgs; [
      kodi
      inputstreamhelper
      inputstream-adaptive
      inputstream-ffmpegdirect
      inputstream-rtmp
      inputstreamhelper
      inputstream-adaptive
      inputstream-ffmpegdirect
      inputstream-rtmp
      # vfs-libarchive
      # vfs-rar
      youtube
      netflix
      sendtokodi
      websocket
      # urllib3
      certifi
      keymap
      trakt
      future
      urllib3
      # pvr-hts
      signals
      iagl
    ]);
in {
  options.gui."media-center" = {enable = mkEnableOption "gui.media-center";};

  config = mkIf cfg.enable {
    system.nixos.tags = ["media-center"];
    #    xdg.portal.enable = mkForce false;

    programs.dconf.enable = true;

    sound = {
      enable = false;
      mediaKeys.enable = true;
    };

    security.rtkit.enable = true;

    services = {
      cage = {
        user = "media";
        program = "${kodi}/bin/kodi-standalone";
        enable = true;
      };

      kmscon = {enable = mkForce false;};

      pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        # If you want to use JACK applications, uncomment this
        # jack.enable = true;
        # extraConfig.pipewire-pulse."92-tcp" = {
        #   context.modules = [
        #     {
        #       name = "module-native-protocol-tcp";
        #       args = {};
        #     }
        #     {
        #       name = "module-zeroconf-publish";
        #       args = {};
        #     }
        #   ];
        #   stream.properties = {
        #     node.latency = "32/48000";
        #     resample.quality = 1;
        #   };
        # };
      };
    };

    apps.flatpak.enable = mkForce false;

    gui = {
      gnome.enable = mkForce false;
      quiet-boot.enable = mkForce false;
    };

    systemd = {
      user.tmpfiles.users.media.rules = [
        #   "d /home/media/.kodi/cdm 0777 media users -"
        "L+ /home/media/.kodi/cdm/libwidevinecdm.so - - - - ${pkgs.custom.widevine}/lib/libwidevinecdm.so"
      ];

      targets = {
        sleep.enable = mkForce false;
        suspend.enable = mkForce false;
        hibernate.enable = mkForce false;
        hybrid-sleep.enable = mkForce false;
      };
    };

    programs.nix-ld = {
      enable = true;
      libraries = [
        pkgs.stdenv.cc.cc
        pkgs.openssl
        pkgs.glib
        # ...
      ];
    };

    hardware = {
      opengl = {
        enable = true;
        extraPackages = with pkgs; [libva vaapiVdpau libvdpau-va-gl];
        driSupport = true;
      };
    };

    environment.systemPackages = with pkgs; [
      celluloid
      pwvucontrol
      kodi-cli
      libcec_platform
      libcec

      pkgs.custom.widevine
    ];

    boot = {
      kernelParams = ["quiet"];
      plymouth = {enable = true;};
    };

    users.users.media = {
      isNormalUser = true;
      uid = 1100;
      extraGroups = ["data" "video" "audio" "input"];
    };

    # home-manager = {
    #   users.media = {
    #     home.stateVersion = mkDefault "24.05";
    #     xdg.enable = true;
    #   };
    # };

    networking.firewall = {
      enable = mkForce false;
    };
  };
}
