{ lib, pkgs, osConfig, ... }:
let inherit (pkgs) stdenvNoCC;
in {
  imports = [ ./match-blocks.nix ];
  config = {
    programs.ssh = {
      enable = true;
      forwardAgent = true;
      matchBlocks = {
        "*" = {
          forwardAgent = true;
          extraOptions = if stdenvNoCC.isDarwin then {
            "IdentityAgent" = "/Users/tomas/.1password/agent.sock";
            # "UseKeychain" = "yes";
          } else {
            "PKCS11Provider" = if (osConfig.traits.hardware.tpm.enable
              && osConfig.gui.enable) then
              "/run/current-system/sw/lib/libtpm2_pkcs11.so"
            else
              "/run/current-system/sw/lib/libykcs11.so";

            "IdentityAgent" =
              lib.mkIf osConfig.gui.enable "/home/tomas/.1password/agent.sock";
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
