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
  options.apps._1password = {enable = lib.mkEnableOption "1Password" // {default = true;};};

  config = lib.mkIf cfg.enable {
    programs = {
      ssh.extraConfig = lib.mkIf config.gui.desktop.enable ''
        IdentityAgent /home/tomas/.1password/agent.sock
      '';

      _1password = {
        enable = true;
        package = pkgs._1password;
      };

      _1password-gui = lib.mkIf config.gui.desktop.enable {
        enable = true;
        polkitPolicyOwners = ["tomas" "root"];
        package = pkgs._1password-gui;
      };
    };
  };
}
