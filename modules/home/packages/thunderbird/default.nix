{
  lib,
  config,
  ...
}: {
  config = {
    programs.thunderbird = {
      enable = true;

      profiles = {
        "Tomas Harkema" = {
          isDefault = true;
        };
      };
    };
  };
}
