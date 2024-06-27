{
  lib,
  pkgs,
  config,
  inputs,
  ...
}:
with lib; let
  cfg = config.apps.steam;
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
    enable = mkEnableOption "steam";
  };

  config = mkIf cfg.enable {
    system.nixos.tags = ["steam"];
    boot.kernelModules = ["uinput"];
    users.groups.input.members = ["tomas"];

    programs = {
      steam = {
        enable = true;

        remotePlay.openFirewall = true;
        dedicatedServer.openFirewall = true;
        gamescopeSession.enable = true;
        platformOptimizations.enable = true;
      };
      gamescope = {
        enable = true;
        capSysNice = true;
      };
    };

    #    programs.mangohud = {
    #      enable = true;
    #      enableSessionWide = true;
    #      settings = {
    #        full = true;
    #    no_display = true;
    #        cpu_load_change = true;
    #      };
    #   };

    environment.systemPackages = with pkgs; [
      # sunshine
      protontricks
      # heroic
      gamehub
      cartridges
      steamcmd
      # steam-run
      adwsteamgtk
      steam-tui
      mangohud
    ];

    # services.udev.extraRules = ''
    #   Sunshine
    #   KERNEL=="uinput", SUBSYSTEM=="misc", OPTIONS+="static_node=uinput", TAG+="uaccess"
    # '';
    # security.wrappers.sunshine = {
    #   owner = "root";
    #   group = "root";
    #   capabilities = "cap_sys_admin+p";
    #   source = "${pkgs.sunshine}/bin/sunshine";
    # };

    # systemd.user.services.sunshine = {
    #   description = "sunshine";
    #   wantedBy = ["graphical-session.target"];
    #   serviceConfig = {
    #     ExecStart = "${config.security.wrapperDir}/sunshine";
    #   };
    # };

    # services.avahi.publish.userServices = true;
    # Enable OpenGL
    hardware.opengl = {
      enable = true;
      driSupport = true;
      driSupport32Bit = true;

      extraPackages = with pkgs; [mangohud];
      extraPackages32 = with pkgs; [mangohud];
    };
  };
}
