{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib) types;
  inherit (lib.custom) mkOpt;

  cfg = config.user;
in {
  options.user = with types; {
    name = mkOpt str "tomas" "The name to use for the user account.";

    # keys = mkOpt (listOf str) keys "auth keys";
    fullName = mkOpt str "Tomas Harkema" "The full name of the user.";
    email = mkOpt str "tomas@harkema.io" "The email of the user.";
    #   initialPassword =
    #     mkOpt str "password"
    #     "The initial password to use when the user is first created.";
    #   icon =
    #     mkOpt (nullOr package) defaultIcon
    #     "The profile picture to use for the user.";
    #   prompt-init = mkBoolOpt true "Whether or not to show an initial message when opening a new shell.";
    #   extraGroups = mkOpt (listOf str) [] "Groups for the user to be assigned.";
    #   extraOptions =
    #     mkOpt attrs {}
    #     (mdDoc "Extra options passed to `users.users.<name>`.");
  };

  config = {
    # users.users.${cfg.name} = {
    #   # NOTE: Setting the uid here is required for another
    #   # module to evaluate successfully since it reads
    #   # `users.users.${config.user.name}.uid`.
    #   uid = "1000";
    # };

    programs.zsh = {
      enable = true;
    };

    environment.systemPackages =
      (with pkgs; [
        # atuin
        terminal-notifier

        sysz
        # iptraf-ng
        # netscanner
        bandwhich
        bashmount
        bmon
        ctop

        # devtodo
        devdash
      ])
      ++ (with pkgs.custom; [
        launchcontrol
        # ztui
        maclaunch
        tailscale-tui
      ])
      ++ (with pkgs.darwin; [lsusb]);
    security.pam.enableSudoTouchIdAuth = true;
  };
}
