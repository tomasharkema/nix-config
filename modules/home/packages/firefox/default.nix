{
  pkgs,
  lib,
  osConfig,
  ...
}: {
  config = {
    programs.firefox = lib.mkIf (pkgs.stdenv.isLinux && osConfig.gui.enable) {
      enable = true;
      # enableGnomeExtensions = true;
      package = osConfig.programs.firefox.package;
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
