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
      # controlMaster = "auto";
      # controlPersist = "10m";
      # addKeysToAgent = true;
      hashKnownHosts = true;

      extraConfig = ''
        Match host * exec "test -z $SSH_TTY"
          IdentityAgent ${onePasswordSocket}
      '';

      matchBlocks = {
        "ssh.dev.azure.com" = {
          hostname = "ssh.dev.azure.com";
          extraOptions = {
            IdentityAgent = onePasswordSocket;
          };
        };

        "ipa.harkema.io" = {
          hostname = "ipa.harkema.io";
          user = "root";
          extraOptions = {
            "IdentityAgent" = onePasswordSocket;
          };
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
        silver-star = {
          hostname = "silver-star";
          user = "root";
          forwardAgent = true;
          extraOptions = {
            # RequestTTY = "yes";
            # RemoteCommand = "tmux new -A -s \$\{\%n\}";
          };
        };
      };
    };
  };
}
