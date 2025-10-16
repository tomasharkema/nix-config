{
  lib,
  pkgs,
  config,
  inputs,
  ...
}: let
  cfg = config.apps.steam;

  sunshineOverride =
    (pkgs.sunshine.override {
      cudaSupport = true;
      stdenv = pkgs.cudaPackages.backendStdenv;
    })
    .overrideAttrs (prev: {
      runtimeDependencies = prev.runtimeDependencies ++ [pkgs.libglvnd];
    });
in {
  # disabledModules = [
  #   "services/desktops/pipewire/pipewire.nix"
  #   "services/desktops/pipewire/wireplumber.nix"
  # ];

  # imports = [
  #   "${inputs.unstable}/nixos/modules/services/desktops/pipewire/pipewire.nix"
  #   "${inputs.unstable}/nixos/modules/services/desktops/pipewire/wireplumber.nix"
  #   #   "${inputs.unstable}/nixos/modules/security/pam.nix"
  #   #   "${inputs.unstable}/nixos/modules/security/krb5"
  # ];

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
        #   gamemode.members = ["tomas"];
        #   "steam".name = "steam";
      };
    };

    programs = {
      steam = {
        enable = true;
        extest.enable = true;

        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
        gamescopeSession.enable = true;
        platformOptimizations.enable = true;
        localNetworkGameTransfers.openFirewall = true;
        protontricks.enable = true;
      };
      gamescope = {
        enable = true;
        capSysNice = true;
      };

      # gamemode.enable = true;
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
