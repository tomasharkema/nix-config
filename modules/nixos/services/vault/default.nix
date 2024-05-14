{ config, pkgs, lib, ... }: {
  config = lib.mkIf false {
    services.vault-agent = {
      instances = {
        "silver-star" = {
          enable = true;
          settings = {
            template = [{
              source = "/tmp/agent/template.ctmpl";
              destination = "/tmp/agent/render.txt";
              error_on_missing_key = true;
            }];
            vault = { address = "http://silver-star.ling-lizard.ts.net:8200"; };
          };
        };
      };
    };
  };
}
