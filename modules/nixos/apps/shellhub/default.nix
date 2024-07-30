{
  pkgs,
  config,
  lib,
  ...
}:
with lib; {
  config = {
    age.secrets.shellhub = {
      rekeyFile = ./shellhub.age;
      path = "/var/lib/shellhub-agent/private.key";
    };

    services.shellhub-agent = {
      enable = true;
      tenantId = "2d2799eb-43c0-4478-b080-ddcf22f49a29";
      privateKey = config.age.secrets.shellhub.path;
      preferredHostname = config.networking.hostName;
    };

    systemd.tmpfiles.rules = [
      "L+  /var/lib/shellhub-agent/private.key.pub  -  -  -  -  ${pkgs.writeText "private.key.pub" "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILCswh/1hPkXtoqsdkYvqf2KYm3WcMvflpc7F1jQPpo2 tomas@voltron"}"
    ];
  };
}
