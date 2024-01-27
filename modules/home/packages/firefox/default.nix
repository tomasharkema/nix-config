{
  pkgs,
  lib,
  ...
}: {
  config = {
    programs.firefox = lib.mkIf pkgs.stdenv.isLinux {
      enable = true;
      enableGnomeExtensions = true;
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
