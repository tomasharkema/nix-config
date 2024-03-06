{
  config,
  pkgs,
  ...
}: {
  config = {
    services.monit = {
      enable = true;
    };
  };
}
