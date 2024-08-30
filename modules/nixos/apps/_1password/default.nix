{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
with lib;
with lib.custom; let
  cfg = config.apps._1password;
  # unstable = inputs.unstable.legacyPackages."${pkgs.system}";
in {
  options.apps._1password = {enable = mkBoolOpt true "1Password";};

  # disabledModules = [
  #   "programs/_1password.nix"
  #   "programs/_1password-gui.nix"
  # ];

  # imports = [
  #   "${inputs.unstable}/nixos/modules/programs/_1password.nix"
  #   "${inputs.unstable}/nixos/modules/programs/_1password-gui.nix"
  # ];

  config = mkIf cfg.enable {
    programs = {
      ssh.extraConfig = mkIf config.gui.desktop.enable ''
        IdentityAgent /home/tomas/.1password/agent.sock
      '';

      _1password = {
        enable = true;
        package = pkgs._1password;
      };

      _1password-gui = mkIf config.gui.desktop.enable {
        enable = true;
        polkitPolicyOwners = ["tomas" "root"];
        package = pkgs._1password-gui;
      };
    };
  };
}
