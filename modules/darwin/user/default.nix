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

    security.pam.enableSudoTouchIdAuth = true;

    programs.zsh = {
      enable = true;
    };

    environment.systemPackages =
      (with pkgs; [
        # atuin

        sysz
        # iptraf-ng
        # netscanner
        bandwhich
        bashmount
        bmon
        ctop

        # devtodo
        # devdash
      ])
      ++ (with pkgs.custom; [
        launchcontrol
        # ztui
        maclaunch
        tailscale-tui
      ])
      ++ (with pkgs.darwin; [lsusb]);
  };
}
