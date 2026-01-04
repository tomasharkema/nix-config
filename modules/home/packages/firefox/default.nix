{
  pkgs,
  lib,
  osConfig,
  ...
}: {
  config = lib.mkIf (pkgs.stdenv.isLinux && osConfig.gui.enable) {
    programs.firefox = {
      enable = true;
      enableGnomeExtensions = true;

      nativeMessagingHosts = [
        pkgs.custom.firefox-webserial
      ];

      # enable = true;
      # enableGnomeExtensions = true;
      # package = osConfig.programs.firefox.package;
      # TODO: Profile for themeing
      # profiles."tomas" = {
      #   extensions = with pkgs.firefox-addons; [
      #   ];
      #   isDefault = true;
      #   name = "Tomas";
      # };
    };
    # programs.firefox-addons = with pkgs.firefox-addons; [
    #   https-everywhere
    #   privacy-badger
    # ];
  };
}
