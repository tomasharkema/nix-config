{
  config,
  pkgs,
  lib,
  ...
}:
with lib; let
  cfg = config.trait.server;
in {
  options.trait.server = {
    enable = mkEnableOption "server";
  };
  config = mkIf cfg.enable {
    headless.hypervisor.webservices.enable = true;
  };
}
