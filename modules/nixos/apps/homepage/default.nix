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

    services.homepage-dashboard = {
      enable = true;

      services = [
        {
          nixos =
            map (machine: let
              tsUrl = "https://${machine}.ling-lizard.ts.net";
            in {
              "${machine}" = {
                href = tsUrl;
                siteMonitor = tsUrl;
              };
            })
            self.machines.all;
        }
      ];
    };
  };
}
