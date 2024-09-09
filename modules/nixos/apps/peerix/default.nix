{
  pkgs,
  config,
  lib,
  ...
}: {
  # config = {
  #   age.secrets = {
  #     "peerix-public" = {
  #       rekeyFile = ./peerix.public.age;
  #       mode = "644";
  #     };

  #     "peerix-private" = {
  #       rekeyFile = ./peerix.private.age;
  #       # mode = "644";
  #       owner = config.services.peerix.user;
  #       group = config.services.peerix.group;
  #     };
  #   };

  #   services.peerix = {
  #     enable = true;
  #     publicKey = "tomas-peerix-1:dhTsRgEPg+CLBM5VNj90mFJXRURZXM/vjGD/Cf6EwWI=";
  #     privateKeyFile = config.age.secrets."peerix-private".path;
  #     openFirewall = true;
  #   };
  # };
}
