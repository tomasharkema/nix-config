{
  lib,
  pkgs,
  config,
  inputs,
  ...
}: let
  cfg = config.apps.steam;
in {
  options.apps.steam = {
    enable = lib.mkEnableOption "steam";

    sunshine = lib.mkEnableOption "sunshine";
  };

  config = lib.mkIf cfg.enable {
    system.nixos.tags = ["steam"];

    boot.kernelModules = ["uinput"];

    users = {
      users = {
        # "steam" = {
        #   linger = true;

        #   isNormalUser = true;
        #   group = "steam";

        #   home = "/home/steam";
        #   extraGroups = ["video" "audio" "input" "users"];
        # };

        # sunshine = {
        #   linger = true;
        #   isNormalUser = true;
        #   home = "/home/sunshine";
        #   description = "Sunshine Server";
        #   extraGroups = ["wheel" "networkmanager" "input" "video"];
        # };
      };
      groups = {
        input.members = ["tomas"];
        gamemode.members = ["tomas"];
        #   "steam".name = "steam";
      };
    };

    programs = {
      wine = {
        enable = true;
        binfmt = true;
        ntsync = true;
      };

      steam = {
        enable = true;

        extraPackages = with pkgs; [gamescope];
        extest.enable = true;

        remotePlay.openFirewall = true;
        #dedicatedServer.openFirewall = true;
        # gamescopeSession = {
        #   enable = true;
        #   env = {
        #     __NV_PRIME_RENDER_OFFLOAD = "1";
        #     __VK_LAYER_NV_optimus = "NVIDIA_only";
        #     __GLX_VENDOR_LIBRARY_NAME = "nvidia";
        #   };
        # };
        #platformOptimizations.enable = true;
        localNetworkGameTransfers.openFirewall = true;
        protontricks.enable = true;
      };
      # gamescope = {
      #   enable = true;
      #   capSysNice = true;
      #   env = {
      #     __NV_PRIME_RENDER_OFFLOAD = "1";
      #     __VK_LAYER_NV_optimus = "NVIDIA_only";
      #     __GLX_VENDOR_LIBRARY_NAME = "nvidia";
      #   };
      # };

      gamemode = {
        enable = true;
        # settings = {
        #   general = {
        #     renice = 10;
        #   };

        #   custom = {
        #     start = "${pkgs.libnotify}/bin/notify-send 'GameMode started'";
        #     end = "${pkgs.libnotify}/bin/notify-send 'GameMode ended'";
        #   };
        # };
      };
    };

    # programs.mangohud = {
    #   enable = true;
    #   enableSessionWide = true;
    #   settings = {
    #     full = true;
    #     #    no_display = true;
    #     cpu_load_change = true;
    #   };
    # };

    environment.systemPackages = with pkgs; [
      # sunshine
      protontricks
      heroic
      # gamehub
      cartridges
      steamcmd
      steam-run
      adwsteamgtk
      steam-tui
      # mangohud
      extest
      bottles
      winetricks
    ];

    # services = lib.mkIf cfg.sunshine {
    #   avahi.publish.userServices = true;

    #   udev.extraRules = ''
    #     KERNEL=="uinput", SUBSYSTEM=="misc", OPTIONS+="static_node=uinput", TAG+="uaccess"
    #     KERNEL=="uinput", GROUP="input", MODE="0660", OPTIONS+="static_node=uinput"
    #   '';

    #   jack.loopback.enable = true;
    #   sunshine = {
    #     enable = true;
    #     package = sunshineOverride;
    #     # capSysAdmin = true;
    #     openFirewall = true;
    #     autoStart = true;
    #   };
    # };

    # security = {
    #   sudo.extraRules = lib.mkIf cfg.sunshine [
    #     {
    #       users = ["sunshine"];
    #       commands = [
    #         {
    #           command = "ALL";
    #           options = ["NOPASSWD"];
    #         }
    #       ];
    #     }
    #   ];
    # };

    # Enable OpenGL
    hardware.graphics = {
      enable = true;

      enable32Bit = true;

      # extraPackages = with pkgs; [mangohud];
      # extraPackages32 = with pkgs; [mangohud];
    };
  };
}
