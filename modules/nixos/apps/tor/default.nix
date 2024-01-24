{pkgs, ...}: {
  config = {
    environment.systemPackages = with pkgs; [tor];

    services.tor = {
      enable = true;
      client.enable = true;

      enableGeoIP = false;

      relay.onionServices = {
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
}
