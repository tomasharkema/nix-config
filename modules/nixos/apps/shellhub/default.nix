{
  pkgs,
  config,
  lib,
  ...
}: {
  config = {
    services.shellhub-agent = {
      enable = true;
      tenantId = "2d2799eb-43c0-4478-b080-ddcf22f49a29";
      preferredHostname = config.networking.hostName;
    };
  };
}
