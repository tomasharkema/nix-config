{
  lib,
  pkgs,
  config,
  ...
}: let
  cfg = config.apps.mailrise;
in {
  options.apps.mailrise = {enable = lib.mkEnableOption "mailrise";};

  config = lib.mkIf cfg.enable {
    age.secrets = {
      notify = {
        rekeyFile = ./notify.age;
        # owner = "tomas";
        # group = "tomas";
        mode = "644";
        # path = "/home/tomas/.config/notify/provider-config.yaml";
        # symlink = false;
      };
    };

    services.mailrise = {
      enable = true;

      settings = {
        configs = {
          "systemd@*" = {
            urls = ["tgram://TGRAM_SECRET/TGRAM_CHAT_ID/?image=No"];
          };
          "*@*" = {
            urls = [
              "ntfys://NTFY_TOPIC"
              "tgram://TGRAM_SECRET/TGRAM_CHAT_ID/?image=No"
            ];
          };
        };
        smtp = {
          # auth = { basic = { "admin" = "admin"; }; };
        };
      };
      secrets = {
        TGRAM_CHAT_ID = "<(${pkgs.bash}/bin/sh -c 'source ${config.age.secrets.notify.path}; echo $TGRAM_CHAT_ID')";
        TGRAM_SECRET = "<(${pkgs.bash}/bin/sh -c 'source ${config.age.secrets.notify.path}; echo $TGRAM_SECRET')";
        NTFY_TOPIC = "<(${pkgs.coreutils}/bin/cat ${config.age.secrets.ntfy.path})";
      };
    };
  };
}
