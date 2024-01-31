{
  pkgs,
  lib,
  config,
  ...
}:
with lib; let
  cfgRelay = mkIf config.apps.tor.relay;
in {
  options.apps.tor = {
    relay = {
      enable = mkBoolOpt false "Enable the tor relay";
    };
  };

  config = {
    environment.systemPackages = with pkgs; [
      tor
      tor-browser-bundle-bin
    ];

    services.tor = {
      enable = true;
      client.enable = true;

      enableGeoIP = false;

      openFirewall = true;

      settings = {
        UseBridges = true;
        ClientTransportPlugin = "obfs4 exec ${pkgs.obfs4}/bin/obfs4proxy";
        ContactInfo = mkIf cfgRelay.enable "lipids.tubule.0o@icloud.com";
        Nickname = mkIf cfgRelay.enable "lipids.tubule.0o";
        ORPort = 9001;
        ControlPort = 9051;
        BandWidthRate = mkIf cfgRelay.enable "10 MBytes";
      };

      relay = {
        enable = true;

        role = mkIf cfgRelay.enable "relay";

        onionServices = {
          ssh = {
            version = 3;
            map = [
              {
                port = 22222;
                target = {
                  addr = "127.0.0.1";
                  port = 22;
                };
              }
            ];
          };
        };
      };
    };
  };
}
