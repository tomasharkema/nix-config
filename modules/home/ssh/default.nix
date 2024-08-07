{
  lib,
  pkgs,
  osConfig,
  ...
}:
with lib; {
  imports = [./match-blocks.nix];
  config = {
    programs.ssh = {
      enable = true;
      forwardAgent = true;
      matchBlocks = {
        "*" = {
          forwardAgent = true;
          extraOptions =
            if pkgs.stdenvNoCC.isDarwin
            then {
              "IdentityAgent" = "/Users/tomas/.1password/agent.sock";
              # "UseKeychain" = "yes";
            }
            else {
              # "PKCS11Provider" =
              #   if
              #     (osConfig.trait.hardware.tpm.enable
              #       && osConfig.gui.enable)
              #   then "/run/current-system/sw/lib/libtpm2_pkcs11.so"
              #   else "${pkgs.yubico-piv-tool}/lib/libykcs11.so";

              # "IdentityAgent" = mkIf osConfig.gui.enable "/home/tomas/.1password/agent.sock";
            };
        };
        silver-star = {
          hostname = "silver-star";
          user = "root";
          forwardAgent = true;
          extraOptions = {
            RequestTTY = "yes";
            # RemoteCommand = "tmux new -A -s \$\{\%n\}";
          };
        };
      };
    };
  };
}
