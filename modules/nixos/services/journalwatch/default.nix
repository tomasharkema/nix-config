{
  pkgs,
  config,
  ...
}: {
  config = {
    environment.systemPackages = [pkgs.mailutils];

    proxy-services.services = {
      "/inbox" = {
        proxyPass = "http://unix:${config.services.public-inbox.http.port}:/inbox";
      };
    };

    services = {
      postfix = {
        enable = true;
      };

      mailcatcher.enable = true;

      public-inbox = {
        enable = true;
        postfix.enable = true;
        nntp.enable = true;
        imap.enable = true;
        http = {
          enable = true;
          port = "/run/public-inbox-httpd.sock";
          mounts = ["/" "/inbox" "/inbox/lists/tomas" "/lists/tomas"];
        };
        mda.enable = true;

        settings = {
          publicinbox.wwwlisting = "all";
        };

        inboxes = {
          tomas = {
            description = "tomas";
            address = ["tomas" "tomas@harkema.io" "tomas@harkema.intra"];
            url = "https://${config.proxy-services.vhost}/inbox/lists/tomas";
          };
        };
      };

      journalwatch = {
        enable = true;
        mailTo = "tomas@harkema.io";
      };
    };
  };
}
