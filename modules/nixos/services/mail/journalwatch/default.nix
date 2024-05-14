{ pkgs, config, ... }: {
  config = {
    # environment.systemPackages = [pkgs.mailutils];

    # systemd.tmpfiles.rules = let
    #   svc = config.systemd.services.public-inbox-httpd.serviceConfig;
    # in [
    #   "d '/var/spool/mail/tomas' 0744 tomas tomas -"
    #   "d '/var/spool/mail/tomas@harkema.intra' 0744 tomas tomas -"
    #   # "d '/var/log/public-inbox' 0700 ${svc.User} ${svc.Group}"
    #   # "Z '/var/log/public-inbox' - ${svc.User} ${svc.Group}"
    #   # "f '/var/log/public-inbox/https.out.log' 0755 ${svc.User} ${svc.Group} - "
    # ];

    services = {
      # postfix = {
      #   enable = true;
      # };

      # mailcatcher.enable = true;

      # journalwatch = {
      #   enable = true;
      #   mailTo = "tomas";
      # };
    };
  };
}
