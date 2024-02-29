{...}: {
  config = {
    services.journalwatch = {
      enable = true;
      mailTo = "tomas+logcheck@harkema.io";
    };
  };
}
