{
  lib,
  pkgs,
  config,
  ...
}:
with lib; {
  config = {
    age.secrets."notify-sub" = {
      rekeyFile = ./notify-sub.age;
    };
  };
}
