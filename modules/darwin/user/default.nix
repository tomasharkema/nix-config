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
        ztui
        maclaunch
        tailscale-tui
      ])
      ++ (with pkgs.darwin; [lsusb]);
    security.pam.enableSudoTouchIdAuth = true;
  };
}
