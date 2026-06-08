{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.user;
in {
  options.user = {
    name = lib.mkOption {
      type = lib.types.str;
      default = "tomas";
      description = "The name to use for the user account.";
    };

    # keys = mkOpt (listOf str) keys "auth keys";
    fullName = lib.mkOption {
      type = lib.types.str;
      default = "Tomas Harkema";
      description = "The full name of the user.";
    };
    email = lib.mkOption {
      type = lib.types.str;
      default = "tomas@harkema.io";
      description = "The email of the user.";
    };
  };

  config = {
    users.users.${cfg.name} = {
      #   # NOTE: Setting the uid here is required for another
      #   # module to evaluate successfully since it reads
      #   # `users.users.${config.user.name}.uid`.
      uid = 501;
    };
    security.pam.services.sudo_local.touchIdAuth = true;

    programs.zsh = {
      enable = true;
    };

    environment.systemPackages =
      (with pkgs; [
        # keep-sorted start
        bandwhich
        bashmount
        bmon
        ctop
        sysz
        # devtodo
        # devdash
        # keep-sorted end
      ])
      ++ (with pkgs.custom; [
        # keep-sorted start
        maclaunch
        # launchcontrol
        rust-conn
        tailscale-tui
        # keep-sorted end
      ])
      ++ (with pkgs.darwin; [lsusb]);
  };
}
