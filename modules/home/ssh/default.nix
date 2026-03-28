{
  lib,
  pkgs,
  osConfig,
  config,
  ...
}: {
  imports = [./match-blocks.nix];

  config = {
    services.gnome-keyring.enable = true;
    home.packages = [pkgs.gcr];

    programs.ssh = {
      enable = true;

      # serverAliveInterval = 60;
      # controlMaster = "auto";
      # controlPersist = "30m";

      # addKeysToAgent = true;
      # hashKnownHosts = true;
      enableDefaultConfig = false;
      # controlPath = null;

      matchBlocks = {
        "allNonSSH1p" = lib.mkIf (!pkgs.stdenvNoCC.isDarwin && osConfig.apps._1password.gui.enable) {
          host = "*";
          match = "host * exec \"test -z $SSH_TTY\"";
          identityAgent = "${config.home.homeDirectory}/.1password/agent.sock";
          # pKCS11Provider =
          #   if pkgs.stdenvNoCC.isDarwin
          #   then "${pkgs.yubico-piv-tool}/lib/libykcs11.dylib"
          #   else "${pkgs.yubico-piv-tool}/lib/libykcs11.so";
          forwardAgent = true;
        };
        "allNonSSHTPM" = lib.mkIf (!pkgs.stdenvNoCC.isDarwin && true) {
          host = "*";
          match = "host * exec \"test -z $SSH_TTY\"";
          identityAgent = "/run/user/1000/ssh-tpm-agent.sock";
          # pKCS11Provider =
          #   if pkgs.stdenvNoCC.isDarwin
          #   then "${pkgs.yubico-piv-tool}/lib/libykcs11.dylib"
          #   else "${pkgs.yubico-piv-tool}/lib/libykcs11.so";
          forwardAgent = true;
        };
        "all1P" = lib.mkIf osConfig.apps._1password.gui.enable {
          host = "*";
          identityAgent = "${config.home.homeDirectory}/.1password/agent.sock";
        };
        "allSSH" = {
          host = "*";
          match = "host * exec \"test -n $SSH_TTY\"";
          # identityAgent = onePasswordSocket;
          #   extraOptions = {
          #     IdentityAgent = onePasswordSocket;
          #     PKCS11Provider =
          #       if pkgs.stdenvNoCC.isDarwin
          #       then "${pkgs.yubico-piv-tool}/lib/libykcs11.dylib"
          #       else "${pkgs.yubico-piv-tool}/lib/libykcs11.so";
          #   };
        };
        "aur.archlinux.org" = {
          extraOptions = {
            PubkeyAuthentication = "no";
          };
        };
        "ipa" = {
          hostname = "ipa";
          user = "root";
        };
        "ipa.ling-lizard.ts.net" = {
          hostname = "ipa.ling-lizard.ts.net";
          user = "root";
        };
        "enceladus-kvm" = {
          hostname = "enceladus-kvm";
          user = "root";
        };
        "enceladus-kvm.ling-lizard.ts.net" = {
          hostname = "enceladus-kvm.ling-lizard.ts.net";
          user = "root";
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
