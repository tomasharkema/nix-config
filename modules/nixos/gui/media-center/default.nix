{
  pkgs,
  lib,
  config,
  ...
}: let
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
  options.gui."media-center" = {enable = lib.mkEnableOption "gui.media-center";};

  config = lib.mkIf cfg.enable {
    system.nixos.tags = ["media-center"];
    #    xdg.portal.enable = lib.mkForce false;

    programs.dconf.enable = true;

    # sound = {
    #   enable = false;
    #   mediaKeys.enable = true;
    # };

    security.rtkit.enable = true;

    services = {
      cage = {
        user = "media";
        program = "${kodi}/bin/kodi-standalone";
        enable = true;
      };

      kmscon = {enable = lib.mkForce false;};

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

    apps.flatpak.enable = lib.mkForce false;

    gui = {
      gnome.enable = lib.mkForce false;
      quiet-boot.enable = lib.mkForce false;
    };

    systemd = {
      user.tmpfiles.users.media.rules = [
        #   "d /home/media/.kodi/cdm 0777 media users -"
        "L+ /home/media/.kodi/cdm/libwidevinecdm.so - - - - ${pkgs.custom.widevine}/lib/libwidevinecdm.so"
      ];

      targets = {
        sleep.enable = lib.mkForce false;
        suspend.enable = lib.mkForce false;
        hibernate.enable = lib.mkForce false;
        hybrid-sleep.enable = lib.mkForce false;
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
      graphics = {
        enable = true;
        extraPackages = with pkgs; [libva vaapiVdpau libvdpau-va-gl];

        enable32Bit = true;
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
    #     home.stateVersion = mkDefault "24.11";
    #     xdg.enable = true;
    #   };
    # };

    networking.firewall = {
      enable = lib.mkForce false;
    };
  };
}
