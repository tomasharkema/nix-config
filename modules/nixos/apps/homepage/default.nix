{
  pkgs,
  lib,
  config,
  inputs,
  ...
}: let
  self = inputs.self;
in {
  config = {
    proxy-services.services = {
      "/home" = {
        proxyPass = "http://localhost:${builtins.toString config.services.homepage-dashboard.listenPort}";
        extraConfig = ''
          client_max_body_size 10G;
          rewrite /home(.*) $1 break;
        '';
      };
    };

    services.homepage-dashboard = let
      tsUrl = machine: "https://${machine}.ling-lizard.ts.net";
    in {
      enable = true;

      settings = {
        base = "https://${tsUrl config.networking.hostName}.ling-lizard.ts.net/home/";
      };

      services = [
        {
          nixos =
            map (machine: {
              "${machine}" = {
                href = tsUrl machine;
                siteMonitor = tsUrl machine;
              };
            })
            self.machines.all;
        }
      ];
    };
  };
}
