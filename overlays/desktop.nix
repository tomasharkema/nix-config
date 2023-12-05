{
  networking.networkmanager.enable = true;
  services.xserver.enable = true;
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;
  networking.firewall.enable = false;

  #   services.xrdp.enable = true;
  #   boot.loader.systemd-boot.enable = true;

  # Select internationalisation properties.
  #   i18n.defaultLocale = "en_US.UTF-8";

  #   i18n.extraLocaleSettings = {
  #     LC_ADDRESS = "en_US.UTF-8";
  #     LC_IDENTIFICATION = "en_US.UTF-8";
  #     LC_MEASUREMENT = "en_US.UTF-8";
  #     LC_MONETARY = "en_US.UTF-8";
  #     LC_NAME = "en_US.UTF-8";
  #     LC_NUMERIC = "en_US.UTF-8";
  #     LC_PAPER = "en_US.UTF-8";
  #     LC_TELEPHONE = "en_US.UTF-8";
  #     LC_TIME = "en_US.UTF-8";
  #   };

  #   nixpkgs.config.firefox.enableGnomeExtensions = true;
}
