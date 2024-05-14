{ pkgs, lib, ... }: {
  config = {
    services.postfix = {
      enable = true;

      # config.public-inbox_destination_recipient_limit = lib.mkForce null;

      extraAliases = ''
        tomas@harkema.intra: tomas
        tomas@harkema.io: tomas
      '';

      transport = ''
        tomas sendtelegram:tomas
      '';

      # The public-inbox transport
      masterConfig.sendtelegram = let
        sendtelegram-script = pkgs.writeShellScript "postix-sendtelegram" ''
          set -x
          SENDTELEGRAM_API_TOKEN="$(${pkgs.coreutils}/bin/cat /run/agenix/notify | ${pkgs.yq}/bin/yq '.telegram[0].telegram_api_key' -r)"
          SENDTELEGRAM_CHAT_ID="$(${pkgs.coreutils}/bin/cat /run/agenix/notify | ${pkgs.yq}/bin/yq '.telegram[0].telegram_chat_id' -r)"
          ${pkgs.custom.sendtelegram}/bin/sendtelegram
        '';
      in {
        type = "unix";
        privileged = true;
        command = "pipe";
        args = [ "user=tomas:tomas" "argv=${sendtelegram-script}" ];
      };
    };
  };
}
