{
  pkgs,
  config,
  lib,
  ...
}: let
  privateKeyPub = pkgs.writeText "private.key.pub" ''
    ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC5zrvXuZo9+XZPKOZj/uDcBfAVUHKlF7eF0Z0xYAMc8LZ308gIk7inyno0uOiqgw6xu0u7NTcSIfF+V61EGBrcrW/F4BZn8jnk+MJeJAjI0Z3aK66y2wwk6EHHzOguNBkjRVkfbQpQoB9DdhZWBbtd+JGzLjti0Pg1HPMiRJcXTc5/Z7O5QkM1MEksmyVzx8L6JyvdMiUQTWwGmfsptieCo1K4o9+t2Hedta0400CIpTTUHNB0tgJCyxytQHDJ2Iut81ALwqyMMCpksVrHx8lIKqk76iQ5Lhi1ZdSlOhLrmxWtrsrvALX9o1hngQp20Lc1Ht7QbrWaNLq3uGj7pMZ5bQybdIMutuFNAZFNwD2WBYag5iOEOciqyNvB8TGBP2umjrlU12DakJRX1mwRCd929qIUhEmQ1DWNtwhSsTf+DOomJNPMOwxCR19kZnPPjk8WXfnyJkEdhgHsbUuO/w3oE8lXX1NOHip19ToTIRjqeNml0fdcfSDZ0wPCGVHJr8VoFYfzJslsFJPOgDgbREzRAQ1QSv7oJMdpDV1/MwIjgb5vJbbiCs2CJ5By59s4FWcBXxC5ADxsBehlTr2JVX3DEdVFFs1U9xzeth5ta1tovevWNHKCZyoafL1xiS7tYOuJvNk41N/6YbDSwSp+aJaUDg4+3aEPSEv0gTzoj792MQ== tomas@voltron
  '';
in {
  config = {
    age.secrets.shellhub = {
      rekeyFile = ./shellhub.age;
      path = "/var/lib/shellhub-agent/private.pem";
    };

    services.shellhub-agent = {
      enable = true;
      tenantId = "2d2799eb-43c0-4478-b080-ddcf22f49a29";
      privateKey = config.age.secrets.shellhub.path;
      preferredHostname = config.networking.hostName;
    };

    systemd.tmpfiles.rules = [
      "L+  /var/lib/shellhub-agent/private.pem.pub  -  -  -  -  ${privateKeyPub}"
    ];
  };
}
