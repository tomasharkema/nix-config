{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
# let
#   enable = inputs.self ? shortRev;
# in
{
  # config = lib.mkIf false {
  #   warnings = lib.optional (!enable) "comin turned off!";

  #   services.comin = {
  #     enable = lib.mkDefault enable;
  #     remotes = [
  #       {
  #         name = "origin";
  #         url = "https://github.com/tomasharkema/nix-config";
  #         branches.main.name = "main";
  #       }
  #     ];
  #   };
  # };
}
