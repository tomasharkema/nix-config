{...}: {
  imports = [../blue-fire];
  config = {
    networking.wireless.enable = false;
    traits.slim.enable = true;
  };
}
