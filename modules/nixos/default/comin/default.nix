{
  config,
  pkgs,
  lib,
  inputs,
  ...
}: {
  config = {
    services.comin = {
      comin = {
        enable = lib.mkDefault (inputs.self ? shortRev);
        remotes = [
          {
            name = "origin";
            url = "https://github.com/tomasharkema/nix-config";
            branches.main.name = "main";
          }
        ];
      };
    };
  };
}
