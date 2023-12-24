{config, ...}: {
  age.secrets.wireless = {
    file = ../secrets/wireless.age;
    mode = "0664";
  };
  networking.networkmanager.enable = true;
  networking.wireless = {
    environmentFile = config.age.secrets."wireless".path;
    networks = {
      "Have a good day".psk = "0fcc36c0dd587f3d85028f427c872fead0b6bb7623099fb4678ed958f2150e23";
    };

    # enable = true;
  };
}
