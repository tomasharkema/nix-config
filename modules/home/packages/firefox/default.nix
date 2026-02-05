{
  pkgs,
  lib,
  osConfig,
  ...
}: {
  config = lib.mkIf (pkgs.stdenv.isLinux && osConfig.gui.enable) {
    programs.firefox = {
      enable = true;

      nativeMessagingHosts = [
        pkgs.custom.firefox-webserial
      ];

      # enable = true;
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
