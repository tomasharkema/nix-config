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
  };

  config = mkIf cfg.enable {
    services.xserver.enable = true;
    services.xserver.displayManager.gdm.enable = true;
    services.xserver.desktopManager.gnome.enable = true;

    services.xrdp.enable = true;
    services.xrdp.openFirewall = true;
    services.xrdp.defaultWindowManager = "${pkgs.gnome.gnome-session}/bin/gnome-session";

    i18n.defaultLocale = "en_US.UTF-8";

    sound.enable = true;
    hardware.pulseaudio.enable = true;
    services.xserver.libinput.enable = true;
    programs.mtr.enable = true;
    # programs.gnupg.agent = {
    # enable = true;
    # enableSSHSupport = true;
    # };

    i18n.extraLocaleSettings = {
      LC_ADDRESS = "en_US.UTF-8";
      LC_IDENTIFICATION = "en_US.UTF-8";
      LC_MEASUREMENT = "en_US.UTF-8";
      LC_MONETARY = "en_US.UTF-8";
      LC_NAME = "en_US.UTF-8";
      LC_NUMERIC = "en_US.UTF-8";
      LC_PAPER = "en_US.UTF-8";
      LC_TELEPHONE = "en_US.UTF-8";
      LC_TIME = "en_US.UTF-8";
    };

    environment.systemPackages = with pkgs; [
      gparted
      firefox
      tilix
      vscode
      fira-code-nerdfont
      gnome.gnome-session
      _1password-gui
      transmission
      keybase
      powertop
      keybase_gui
      nix-software-center
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

    services.pipewire.enable = true;
    services.gvfs.enable = true;

    boot.hardwareScan = true;
  };
}
