{
  pkgs,
  config,
  ...
}: {
  config = {
    services.peerix = {
      enable = true;
      user = "tomas";
      group = "tomas";
    };
  };
}
