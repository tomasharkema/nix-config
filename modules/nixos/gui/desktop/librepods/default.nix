{
  config,
  pkgs,
  lib,
  ...
}: {
  config = lib.mkIf false {
    # sessionVariables = {
    #   PHONE_MAC_ADDRESS = "90:4C:C5:2A:82:B4";
    # };

    environment.systemPackages = [pkgs.custom.librepods];
  };
}
