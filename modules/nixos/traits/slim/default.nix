{
  config,
  pkgs,
  lib,
  ...
}:
with lib; {
  # options.traits.slim = {
  #   enable = mkEnableOption "slim";
  # };

  config = {
    services = {
      kmscon = {
        enable = false;
      };
    };
  };
}
