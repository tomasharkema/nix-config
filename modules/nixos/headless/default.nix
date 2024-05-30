{ config, lib, ... }:
with lib;
with lib.custom;
let cfg = config.headless;
in {
  options.headless = { enable = mkBoolOpt false "headless settings"; };

  config = lib.mkIf cfg.enable {
    environment.variables = {
      OP_CONNECT_HOST = "http://silver-star.ling-lizard.ts.net:7080";
      OP_CONNECT_TOKEN = "${config.age.secrets.op.path}";
    };

    programs.zsh.shellInit = ''
      export OP_CONNECT_HOST="http://silver-star.ling-lizard.ts.net:7080"
      export OP_CONNECT_TOKEN="${config.age.secrets.op.path}"
    '';

    # services = {
    #   # self-deploy = {};
    # };

    # boot = {
    #   kernelParams = ["panic=1" "boot.panic_on_fail" "vga=0x317" "nomodeset"];
    #   loader.grub.splashImage = null;
    # };

    # systemd.enableEmergencyMode = false;
  };
}
