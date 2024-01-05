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
  options.user = {
    name = mkOpt types.str "tomas" "The user account.";
    fullName = mkOpt types.str "Tomas Harkema" "The full name of the user.";
    email = mkOpt types.str "tomas@harkema.io" "The email of the user.";
    uid = mkOpt (types.nullOr types.int) 501 "The uid for the user account.";
  };

  config = {
    users.users.${cfg.name} = {
      # NOTE: Setting the uid here is required for another
      # module to evaluate successfully since it reads
      # `users.users.${config.user.name}.uid`.
      # uid = mkIf (cfg.uid != null) cfg.uid;
    };

    snowfallorg.user.${config.user.name}.home.config = {
    };

    programs.zsh = {enable = true;};

    environment.systemPackages = with pkgs; [
      atuin
      custom.maclaunch
      kitty
      terminal-notifier
      custom.launchcontrol
      # vagrant
      # fig
    ];
    security.pam.enableSudoTouchIdAuth = true;
  };
}
