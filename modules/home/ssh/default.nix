{
  lib,
  pkgs,
  osConfig,
  config,
  ...
}: {
  imports = [./match-blocks.nix];

  config = let
    onePasswordSocket =
      if pkgs.stdenvNoCC.isDarwin
      then "${config.home.homeDirectory}/.1password/agent.sock"
      else
        (
          if osConfig.apps._1password.gui.enable
          then "${config.home.homeDirectory}/.1password/agent.sock"
          else "/run/user/1000/ssh-tpm-agent.sock"
        );
  in {
    programs.ssh = {
      enable = true;
      forwardAgent = true;

      serverAliveInterval = 60;
      controlMaster = "auto";
      controlPersist = "30m";

      # addKeysToAgent = true;
      # hashKnownHosts = true;

      matchBlocks = {
        "*" = {
          match = "host * exec \"test -z $SSH_TTY\"";
          extraOptions = {
            IdentityAgent = onePasswordSocket;
            PKCS11Provider =
              if pkgs.stdenvNoCC.isDarwin
              then "${pkgs.yubico-piv-tool}/lib/libykcs11.dylib"
              else "${pkgs.yubico-piv-tool}/lib/libykcs11.so";
          };
        };

        "ipa.ling-lizard.ts.net" = {
          hostname = "ipa.ling-lizard.ts.net";
          user = "root";
          # extraOptions = {
          #   "IdentityAgent" = onePasswordSocket;
          # };
        };
        # "*" = {
        #   forwardAgent = true;
        #   extraOptions =
        #     if pkgs.stdenvNoCC.isDarwin
        #     then {
        #       # "IdentityAgent" = "${config.home.homeDirectory}/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh";
        #       "IdentityAgent" = onePasswordSocket;
        #       # "UseKeychain" = "yes";
        #     }
        #     else {
        #       # "PKCS11Provider" =
        #       #   if
        #       #     (osConfig.traits.hardware.tpm.enable
        #       #       && osConfig.gui.enable)
        #       #   then "/run/current-system/sw/lib/libtpm2_pkcs11.so"
        #       #   else "${pkgs.yubico-piv-tool}/lib/libykcs11.so";

        #       # "IdentityAgent" = mkIf osConfig.gui.enable onePasswordSocket;
        #     };
        # };
        # silver-star = {
        #   hostname = "silver-star";
        #   user = "root";
        #   forwardAgent = true;
        #   extraOptions = {
        #     # RequestTTY = "yes";
        #     # RemoteCommand = "tmux new -A -s \$\{\%n\}";
        #   };
        # };
      };
    };
  };
}
