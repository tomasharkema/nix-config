{
  pkgs,
  lib,
  config,
  ...
}: {
  config = lib.mkIf false {
    environment.systemPackages = with pkgs;
      [tor]
      ++ lib.optional (pkgs.system == "x86_64-linux" && config.gui.enable)
      tor-browser-bundle-bin;

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
