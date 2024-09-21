{
  lib,
  pkgs,
  osConfig,
  config,
  ...
}: {
  imports = [./match-blocks.nix];

  options.programs.ssh = {
    extraIdentityAgent = lib.mkOption {
      type = lib.types.str;
      description = ''
        Path to the ssh-agent socket.
      '';
    };
  };

  config = let
    onePasswordSocket =
      if pkgs.stdenvNoCC.isDarwin
      then "${config.home.homeDirectory}/.1password/agent.sock"
      else "${config.home.homeDirectory}/.1password/agent.sock";
  in {
    programs.ssh = {
      enable = true;
      forwardAgent = true;
      # controlMaster = "auto";
      # controlPersist = "10m";
      # addKeysToAgent = true;
      hashKnownHosts = true;

      extraIdentityAgent = lib.mkDefault onePasswordSocket;

      extraConfig = ''
        IdentityAgent ${config.programs.ssh.extraIdentityAgent}
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
        #       #     (osConfig.trait.hardware.tpm.enable
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
            RequestTTY = "yes";
            # RemoteCommand = "tmux new -A -s \$\{\%n\}";
          };
        };
      };
    };
  };
}
