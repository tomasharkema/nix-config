{ lib, pkgs, config, ... }:
with lib;
let cfg = config.apps.mailrise;
in {
  options.apps.mailrise = { enable = mkEnableOption "mailrise"; };

  config = {
    services.mailrise = mkIf cfg.enable {
      enable = true;

      settings = {
        configs = {
          "*@*" = {
            urls = [
              "ntfys://NTFY_TOPIC"
              "tgram://TGRAM_SECRET/TGRAM_CHAT_ID/?image=Yes"
            ];
          };
          "systemd" = {
            urls = [ "tgram://TGRAM_SECRET/TGRAM_CHAT_ID/?image=Yes" ];
          };
        };
        smtp = {
          # auth = { basic = { "admin" = "admin"; }; };
        };
      };
      secrets = {
        TGRAM_CHAT_ID =
          "<(${pkgs.coreutils}/bin/cat ${config.age.secrets.notify.path} | ${pkgs.yq}/bin/yq '.telegram[0].telegram_chat_id' -r)";
        TGRAM_SECRET =
          "<(${pkgs.coreutils}/bin/cat ${config.age.secrets.notify.path} | ${pkgs.yq}/bin/yq '.telegram[0].telegram_api_key' -r)";
        NTFY_TOPIC =
          "<(${pkgs.coreutils}/bin/cat ${config.age.secrets.ntfy.path})";
      };
    };
  };
}
