{
  pkgs,
  config,
  lib,
  ...
}: {
  config = {
    user.name = "tomas.harkema";
    # snowfall.user.name = "tomas.harkema";
    age = {
      rekey = {
        hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDWE65BK6InX1NGal2iHWI2lCEmh01gQBQpAP2ol+jJD root@Tomas-Harkema-CV404C72JJ";
      };
    };

    home-manager.users."${config.user.name}" = let
      hm = config.home-manager.users."${config.user.name}";
    in {
      # programs.ssh.matchBlocks."*".extraOptions."IdentityAgent" = lib.mkForce "/Users/${config.user.name}/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh";
      # home.sessionVariables.SSH_AUTH_SOCK = lib.mkForce "/Users/${config.user.name}/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh";

      home.sessionVariables = {
        JAVA_HOME = "$(/usr/libexec/java_home -v 21)";
        ANDROID_HOME = "/Users/tomas.harkema/Library/Android/sdk";
      };

      programs = {
        # ssh.extraIdentityAgent = "${hm.home.homeDirectory}/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh";

        git.extraConfig = {
          user.signingKey = lib.mkForce "/Users/tomas.harkema/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/PublicKeys/6cee278709036d893e6a31d818357828.pub";
          gpg = {
            format = "ssh";
            # not needed if SSH_AUTH_SOCK is set...
            # ssh.program = "";
          };
        };
      };
    };
  };
}
