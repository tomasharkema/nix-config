{
  lib,
  pkgs,
  config,
  inputs,
  ...
}: let
  cfg = config.services.local-store;
in {
  imports = [];

  options.services.local-store = {
    enable = lib.mkEnableOption "local-store";
  };

  config = lib.mkIf cfg.enable {
    services = {
      nix-serve = {
        enable = true;
        package = pkgs.nix-serve-ng;
      };
      avahi = {
        enable = true;

        extraServiceFiles.store = ''
          <?xml version="1.0" standalone='no'?><!--*-nxml-*-->
          <!DOCTYPE service-group SYSTEM "avahi-service.dtd">
          <service-group>
            <name replace-wildcards="yes">nix-store</name>
            <service>
              <type>_ssh._tcp</type>
              <port>${builtins.toString config.services.nix-serve.port}</port>
            </service>
          </service-group>
        '';
      };
    };
  };
}
