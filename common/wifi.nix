{ config, ... }: {

  age.secrets.wireless = {
    file = ../secrets/wireless.age;
    mode = "0664";
  };

  networking.wireless = {

    environmentFile = config.age.secrets."wireless".path;
    networks = {
      "Have a good day".psk = "@BRANDON_HOME@";
    };

    # enable = true;
  };

}
