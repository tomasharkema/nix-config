{ config, pkgs, lib, ... }: {
  config = {
    programs.msmtp = {
      enable = true;
      accounts.default = {
        host = "silver-star-vm.ling-lizard.ts.net";
        port = 8025;
        from = "tomas@harkema.io";
        # user = "admin";
        # password = "admin";
      };
    };
  };
}
