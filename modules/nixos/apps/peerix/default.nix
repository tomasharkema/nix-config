{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
{
  config = {
    #   age.secrets = {
    #     "peerix-public" = {
    #       file = ../../../../secrets/peerix.public.age;
    #       mode = "644";
    #     };

    #     "peerix-private" = {
    #       file = ../../../../secrets/peerix.private.age;
    #       mode = "644";
    #     };
    #   };

    services.peerix = {
      enable = true;
      user = "tomas";
      group = "tomas";
      publicKey = "peerix-tomas-1:OBFTUNI1LIezxoFStcRyCHKi2PHExoIcZA0Mfq/4uJA=";
      privateKeyFile = config.age.secrets."peerix-private".path;
      openFirewall = true;
    };
  };
}
