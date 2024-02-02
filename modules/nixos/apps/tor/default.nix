{
  pkgs,
  lib,
  config,
  ...
}: {
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
        # UseBridges = true;
        # ClientTransportPlugin = "obfs4 exec ${pkgs.obfs4}/bin/obfs4proxy";
      };

      relay = {
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
