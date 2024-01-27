{pkgs, ...}: {
  config = {
    programs.firefox = {
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
