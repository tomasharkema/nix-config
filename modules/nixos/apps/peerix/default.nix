{
  pkgs,
  config,
  ...
}: {
  config = {
    age.secrets."peerix-public" = {
      file = ../../../../secrets/peerix.public.age;
      mode = "644";
    };

    age.secrets."peerix-private" = {
      file = ../../../../secrets/peerix.private.age;
      mode = "644";
    };

    services.peerix = {
#      enable = true;
      openFirewall = true;
      user = "tomas";
      group = "tomas";
#      privateKeyFile = "${config.age.secrets.peerix-public.path}";
#      publicKeyFile = "${config.age.secrets.peerix-private.path}";
    };
  };
}
