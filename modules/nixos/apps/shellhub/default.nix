{
  pkgs,
  config,
  lib,
  ...
}: {
  config = lib.mkIf false {
    services.shellhub-agent = {
      enable = true;
      tenantId = "2d2799eb-43c0-4478-b080-ddcf22f49a29";
      preferredHostname = config.networking.hostName;
    };
  };
}
