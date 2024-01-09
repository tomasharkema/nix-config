{config,lib,pkgs,...}: {
  imports = [../arthur];
  config = {
    networking.wireless.enable = false;
    traits.slim.enable = true;
  };
}
