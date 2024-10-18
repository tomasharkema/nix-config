{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  cfg = config.apps._1password;
  # unstable = inputs.unstable.legacyPackages."${pkgs.system}";
in {
  options.apps._1password = {
    enable = lib.mkEnableOption "1Password" // {default = true;};

    gui.enable = lib.mkEnableOption "1Password gui" // {default = config.gui.desktop.enable;};
  };

  config = lib.mkIf cfg.enable {
    programs = {
      # ssh.extraConfig = lib.mkIf config.gui.desktop.enable ''
      #   IdentityAgent /home/tomas/.1password/agent.sock
      # '';

      _1password = {
        enable = true;
        package = pkgs._1password;
      };

      _1password-gui = lib.mkIf cfg.gui.enable {
        enable = true;
        polkitPolicyOwners = ["tomas" "root"];
        package = pkgs._1password-gui;
      };
    };

    environment.sessionVariables = lib.mkIf cfg.gui.enable {
      OP_BIOMETRIC_UNLOCK_ENABLED = "true";
    };
  };
}
