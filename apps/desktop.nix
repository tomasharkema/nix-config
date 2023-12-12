{ pkgs, ... }:
# let
#   nixgui = import (pkgs.fetchFromGitHub {
#     owner = "nix-gui";
#     repo = "nix-gui";
#     # rev = "d4e59eaecb46a74c82229a1d326839be83a1a3ed";
#     # sha256 = "1fy7y4ln63ynad5v9w4z8srb9c8j2lz67fjsf6a923czm9lh5naf";
#   });
# in 
{

  imports = [ ./gnome ];

  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  services.xrdp.enable = true;
  services.xrdp.openFirewall = true;
  services.xrdp.defaultWindowManager =
    "${pkgs.gnome.gnome-session}/bin/gnome-session";

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
    krusader
    transmission
    # moonlight
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
  services.x2goserver.enable = true;
  services.pipewire.enable = true;
  services.gvfs.enable = true;

  boot.hardwareScan = true;

  services.udev = { enable = true; };
}
