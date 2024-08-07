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
      ssh.extraConfig = ''
        IdentityAgent /home/tomas/.1password/agent.sock
        IdentityAgent /run/user/1000/ssh-tpm-agent.sock
        PKCS11Provider /run/current-system/sw/lib/libtpm2_pkcs11.so
        PKCS11Provider ${pkgs.yubico-piv-tool}/lib/libykcs11.so
      '';

      _1password = {
        enable = true;
        package = pkgs.unstable._1password;
      };

      _1password-gui = mkIf config.gui.desktop.enable {
        enable = true;
        polkitPolicyOwners = ["tomas" "root"];
        package = pkgs.unstable._1password-gui;
      };
    };
  };
}
