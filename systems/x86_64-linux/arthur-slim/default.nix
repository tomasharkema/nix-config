{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [../arthur];
  config = {
    networking = {hostName = lib.mkForce "arthur-slim";};
    networking.wireless.enable = false;
    traits.slim.enable = true;
  };
}
