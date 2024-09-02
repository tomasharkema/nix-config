{
  lib,
  pkgs,
  osConfig,
  ...
}:
with lib; {
  imports = [./match-blocks.nix];

  config = let
    onePasswordSocket =
      if pkgs.stdenvNoCC.isDarwin
      then "/Users/${osConfig.user.name}/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
      else "/home/tomas/.1password/agent.sock";
  in {
    programs.ssh = {
      enable = true;
      forwardAgent = true;
      matchBlocks = {
        "ipa.harkema.io" = {
          hostname = "ipa.harkema.io";
          user = "root";
          extraOptions = {
            "IdentityAgent" = onePasswordSocket;
          };
        };
        "*" = {
          forwardAgent = true;
          extraOptions =
            if pkgs.stdenvNoCC.isDarwin
            then {
              "IdentityAgent" = onePasswordSocket;
              # "UseKeychain" = "yes";
            }
            else {
              # "PKCS11Provider" =
              #   if
              #     (osConfig.trait.hardware.tpm.enable
              #       && osConfig.gui.enable)
              #   then "/run/current-system/sw/lib/libtpm2_pkcs11.so"
              #   else "${pkgs.yubico-piv-tool}/lib/libykcs11.so";

              # "IdentityAgent" = mkIf osConfig.gui.enable onePasswordSocket;
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
