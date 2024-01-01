{
  # Snowfall Lib provides a customized `lib` instance with access to your flake's library
  # as well as the libraries available from your flake's inputs.
  lib,
  # An instance of `pkgs` with your overlays and packages applied is also available.
  pkgs,
  # You also have access to your flake's inputs.
  inputs,
  # Additional metadata is provided by Snowfall Lib.
  system, # The system architecture for this host (eg. `x86_64-linux`).
  target, # The Snowfall Lib target for this system (eg. `x86_64-iso`).
  format, # A normalized name for the system target (eg. `iso`).
  virtual, # A boolean to determine whether this system is a virtual target using nixos-generators.
  systems, # An attribute map of your defined hosts.
  # All other arguments come from the module system.
  config,
  ...
}:
with lib; let
  cfg = config.gui.desktop;
in {
  options.gui.desktop = {
    enable = mkEnableOption "hallo";

    rdp = {
      enable = mkEnableOption "hallo";
    };
  };

  config = mkIf cfg.enable {
    services.xserver.enable = true;
    services.xserver.displayManager.gdm.enable = true;
    services.xserver.desktopManager.gnome.enable = true;

    services.xrdp = mkIf cfg.rdp.enable {
      enable = true;
      openFirewall = true;
      defaultWindowManager = "${pkgs.gnome.gnome-session}/bin/gnome-session";
    };

    services.xserver.libinput.enable = true;
    programs.mtr.enable = true;
    # programs.gnupg.agent = {
    # enable = true;
    # enableSSHSupport = true;
    # };

    services.xserver = {
      layout = "us";
      xkbVariant = "";
    };

    environment.systemPackages = with pkgs; [
      gparted
      firefox
      vscode
      fira-code-nerdfont
      transmission
      keybase
      powertop
      # keybase_gui
      nix-software-center
      nixos-conf-editor

      gnome-firmware
      gnome.gnome-session
      gnome.gnome-settings-daemon
      gnome.gnome-shell-extensions
      gnome.gnome-tweaks
      _1password
      _1password-gui
    ];

    # nativeMessagingHosts.packages = with pkgs; [ gnome-browser-connector ];

    # nix.extraOptions = "experimental-features = nix-command flakes";
    security.polkit.enable = true;
    security.polkit.extraConfig = ''
      polkit.addRule(function(action, subject) {
        if (
          subject.isInGroup("users")
            && (
              action.id == "org.freedesktop.login1.reboot" ||
              action.id == "org.freedesktop.login1.reboot-multiple-sessions" ||
              action.id == "org.freedesktop.login1.power-off" ||
              action.id == "org.freedesktop.login1.power-off-multiple-sessions"
            )
          )
        {
          return polkit.Result.YES;
        }
      })
    '';

    # Enable sound with pipewire.
    sound.enable = true;
    hardware.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      jack.enable = true;

      # use the example session manager (no others are packaged yet so this is enabled by default,
      # no need to redefine it in your config for now)
      #    media-session.enable = true;
    };

    services.gvfs.enable = true;

    boot.hardwareScan = true;

    programs.kdeconnect = {
      enable = true;
    };
  };
}
