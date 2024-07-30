{
  pkgs,
  config,
  lib,
  ...
}:
with lib; {
  config = {
    # curl -sSf "https://cloud.shellhub.io/install.sh?tenant_id=2d2799eb-43c0-4478-b080-ddcf22f49a29" | sh

    age.secrets.shellhub.rekeyFile = ./shellhub.age;

    services.shellhub-agent = {
      enable = true;
      tenantId = "2d2799eb-43c0-4478-b080-ddcf22f49a29";

      privateKey = config.age.secrets.shellhub.path;
    };
  };
}
