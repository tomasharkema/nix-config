{
  lib,
  pkgs,
  ...
}:
with lib; {
  config = {
    services.kbfs = {
      enable = true;
    };
  };
}
