{...}: {
  config = {
    services.logcheck = {
      enable = true;
      mailTo = "tomas+logcheck@harkema.io";
    };
  };
}
