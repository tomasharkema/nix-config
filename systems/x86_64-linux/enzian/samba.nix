{
  config,
  pkgs,
  lib,
  ...
}: {
  config = {
    services.samba = {
      enable = true;
      securityType = "user";
      openFirewall = true;
      extraConfig = ''
        workgroup = WORKGROUP
        server string = smbnix
        netbios name = smbnix
        security = user
        #use sendfile = yes
        #max protocol = smb2
        # note: localhost is the ipv6 localhost ::1
        hosts allow = 192.168.178. 172. 100. 127.0.0.1 localhost
        hosts deny = 0.0.0.0/0
        guest account = nobody
        map to guest = bad user
      '';
      shares = {
        public = {
          path = "/run/media/tomas/FFFE-BF91";
          browseable = "yes";
          "read only" = "no";
          "guest ok" = "yes";
          "create mask" = "0644";
          "directory mask" = "0755";
          "force user" = "tomas";
          "force group" = "tomas";
        };
        # private = {
        #   path = "/mnt/Shares/Private";
        #   browseable = "yes";
        #   "read only" = "no";
        #   "guest ok" = "no";
        #   "create mask" = "0644";
        #   "directory mask" = "0755";
        #   "force user" = "username";
        #   "force group" = "groupname";
        # };
      };
    };

    services.samba-wsdd = {
      enable = true;
      openFirewall = true;
    };

    # networking.firewall.enable = true;
    networking.firewall.allowPing = true;
  };
}
