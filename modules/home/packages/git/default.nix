{
  pkgs,
  config,
  ...
}: {
  config = {
    # gh = "op plugin run -- gh ";

    home.packages = [pkgs.custom.git-credential-1password];

    programs = {
      gh = {
        enable = true;
        extensions = with pkgs;
        with pkgs.custom; [
          gh-b
          gh-bump
          gh-changelog
          gh-dash
          gh-milestone
          gh-notify
          gh-poi
          gh-prx
          # gh-tidy
          # gh-todo
          gh-token
          gh-worktree
        ];
        gitCredentialHelper.enable = true;

        settings = {
          git_protocol = "https";
          prompt = "enabled";
        };
      };

      lazygit = {
        enable = true;
        settings = {
          gui.scrollHeight = 2;
        };
      };
      gh-dash.enable = true;

      gitui.enable = true;

      git-worktree-switcher = {
        enable = true;
        enableZshIntegration = true;
      };

      git = {
        enable = true;
        userName = "tomasharkema";
        userEmail = "tomas@harkema.io";

        lfs.enable = true;

        signing = {
          key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILgD7me/mlDG89ZE/tLTJeNhbo3L+pi7eahB2rUneSR4";
          signByDefault = true;
          format = "ssh";
          # signer = "";
        };

        maintenance = {
          enable = true;
          repositories = ["${config.home.homeDirectory}/Developer/nix-config"];
        };
        extraConfig = {
          # maintenance.auto = true;
          rerere = {enable = true;};
          pull = {rebase = true;};
          branch = {autosetupmerge = true;};

          commit.gpgsign = true;
          init.defaultBranch = "main";

          credential.helper = ["${pkgs.custom.git-credential-1password}/bin/git-credential-1password"];

          # gpg = {
          # format = "ssh";

          # not needed if SSH_AUTH_SOCK is set...
          # ssh.program =
          #   lib.mkIf
          #   (pkgs.stdenv.isLinux && osConfig.programs._1password-gui.enable)
          #   "${osConfig.programs._1password-gui.package}/bin/op-ssh-sign";
          # };

          # user.signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILgD7me/mlDG89ZE/tLTJeNhbo3L+pi7eahB2rUneSR4";
        };
      };
    };
  };
}
