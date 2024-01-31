{
  lib,
  config,
  ...
}:
with lib; let
  cfg = config.apps.tor.relay;
in {
  options.apps.tor = {
    relay = {
      enable = mkBoolOpt false "Enable the tor relay";
    };
  };

  config = mkIf cfg.enable {
    services.tor = {
      relay = {
        enable = true;
        role = "relay";
      };
      settings = {
        ContactInfo = "lipids.tubule.0o@icloud.com";
        Nickname = "lipids.tubule.0o";
        ORPort = 9001;
        ControlPort = 9051;
        BandWidthRate = "10 MBytes";
      };
    };
  };
}
