{
  pkgs,
  config,
  lib,
  ...
}: let
  username = "tomasharkema";
in {
  config = {
    # error: Determinate detected, aborting activation
    # Determinate uses its own daemon to manage the Nix installation that
    # conflicts with nix-darwin’s native Nix management.
    #
    # To turn off nix-darwin’s management of the Nix installation, set:
    # nix = lib.mkForce {
    #   enable = false;
    #   linux-builder.enable = false;
    #   gc.automatic = false;
    # };

    user.name = username;
    users.users."${username}".uid = 502;

    age = {
      identityPaths = ["/Users/tomas/.ssh/id_ed25519"];
      rekey = {
        hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIAUtJfbia+28OeSb1FHJoXPUSiBTLOYtk/bx26s1T3bC";
      };
    };

    programs = {
      # ssh.extraIdentityAgent = "/Users/tomasharkema/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh";
      ssh.extraConfig = ''
        Host *
          IdentityAgent "/Users/${username}/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh"

        Host *
          IdentityAgent "/Users/${username}/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
      '';
    };

    home-manager.users."${config.user.name}" = let
      # hm = config.home-manager.users."${config.user.name}";
    in {
      # programs.ssh.matchBlocks."*".extraOptions."IdentityAgent" = lib.mkForce "/Users/${config.user.name}/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh";
      # home.sessionVariables.SSH_AUTH_SOCK = lib.mkForce "/Users/${config.user.name}/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh";

      # home.sessionVariables = {
      #   JAVA_HOME = "$(/usr/libexec/java_home -v 21)";
      #   ANDROID_HOME = "/Users/tomas.harkema/Library/Android/sdk";
      # };

      programs = {
        # ssh.extraIdentityAgent = "/Users/tomasharkema/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh";
        # ssh.extraConfig = ''
        #   Host *
        #     IdentityAgent "/Users/${username}/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh"

        #   Host *
        #     IdentityAgent "/Users/${username}/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
        # '';

        git.extraConfig = {
          # user.signingKey = lib.mkForce "/Users/${username}/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/PublicKeys/c4ea51cf6be5e38b6180d0a1c46adbd8.pub";
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
