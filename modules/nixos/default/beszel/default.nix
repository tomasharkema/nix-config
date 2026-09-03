{
  pkgs,
  config,
  lib,
  ...
}: let
  cfg = config.services.beszel;
in {
  options.services.beszel = {
    enable = lib.mkEnableOption "beszel" // {default = true;};
  };

  config = lib.mkIf cfg.enable {
    # apps.docker.enable = true;

    services.beszel.agent = {
      enable = true;
      environment = {
        PORT = "45876";
        KEY = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKlGr5tWTS9NpbD9YdhBpWUKyaHGQhP7SWQ3BROh41it";
      };
    };
  };
}
