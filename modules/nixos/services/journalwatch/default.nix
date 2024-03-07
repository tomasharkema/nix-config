{
  pkgs,
  config,
  ...
}: {
  config = {
    environment.systemPackages = [pkgs.mailutils];

    systemd.tmpfiles.rules = let
      svc = config.systemd.services.public-inbox-httpd.serviceConfig;
    in [
      "d '/var/spool/mail/tomas' 0744 tomas tomas -"
      "d '/var/spool/mail/tomas@harkema.intra' 0744 tomas tomas -"
      # "d '/var/log/public-inbox' 0700 ${svc.User} ${svc.Group}"
      # "Z '/var/log/public-inbox' - ${svc.User} ${svc.Group}"
      # "f '/var/log/public-inbox/https.out.log' 0755 ${svc.User} ${svc.Group} - "
    ];

    services = {
      postfix = {
        enable = true;
      };

      mailcatcher.enable = true;

      journalwatch = {
        enable = true;
        mailTo = "tomas@harkema.io";
      };

      mailman = {
        enable = true;
        serve.enable = true;
        hyperkitty.enable = true;
        webHosts = ["mail.${config.proxy-services.vhost}"];
        siteOwner = "mailman@harkema.intra";
      };

      postfix = {
        # Not sure limiting to 1 is necessary, but better safe than sorry.
        # config.public-inbox_destination_recipient_limit = "1";
        relayDomains = ["hash:/var/lib/mailman/data/postfix_domains"];

        config = {
          transport_maps = ["hash:/var/lib/mailman/data/postfix_lmtp"];
          local_recipient_maps = ["hash:/var/lib/mailman/data/postfix_lmtp"];
        };

        # Deliver the addresses with the public-inbox transport
        transport = ''
          tomas sendtelegram:tomas
          tomas@harkema.io sendtelegram:tomas@harkema.io
          tomas@harkema.intra sendtelegram:tomas@harkema.intra
        '';

        # The public-inbox transport
        masterConfig.sendtelegram = {
          type = "unix";
          privileged = true; # Required for user=
          command = "pipe";
          args = [
            # "flags=X" # Report as a final delivery
            # "user=${with config.users; users."public-inbox".name + ":" + groups."public-inbox".name}"
            # Specifying a nexthop when using the transport
            # (eg. test public-inbox:test) allows to
            # receive mails with an extension (eg. test+foo).
            "user=tomas:tomas"
            "argv=${pkgs.writeShellScript "postix-sendtelegram" ''
              SENDTELEGRAM_API_TOKEN="$(${pkgs.coreutils}/bin/cat /run/agenix/notify | ${pkgs.yq}/bin/yq '.telegram[0].telegram_api_key')"
              SENDTELEGRAM_CHAT_ID="$(${pkgs.coreutils}/bin/cat /run/agenix/notify | ${pkgs.yq}/bin/yq '.telegram[0].telegram_chat_id')"
              exec ${pkgs.custom.sendtelegram}/bin/sendtelegram
            ''}"
          ];
        };
      };
    };
  };
}
