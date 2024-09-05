{
  pkgs,
  lib,
  osConfig,
  ...
}: {
  config = {
    # gh = "op plugin run -- gh";
    programs = {
      gh = {
        enable = true;
        extensions = with pkgs; [
          gh-dash
          # gh-token
          gh-notify
        ];
        gitCredentialHelper.enable = true;

        settings = {
          git_protocol = "https";
          # prompt = "enabled";
        };
      };

      lazygit.enable = true;

      gh-dash.enable = true;

      gitui.enable = true;

      git = {
        enable = true;
        userName = "tomasharkema";
        userEmail = "tomas@harkema.io";

        lfs.enable = true;

        extraConfig = {
          maintenance.auto = true;
          rerere = {enable = true;};
          pull = {rebase = false;};
          branch = {autosetupmerge = true;};

          commit.gpgsign = true;
          init.defaultBranch = "main";

          gpg = {
            format = "ssh";
            ssh.program =
              lib.mkIf
              (pkgs.stdenv.isLinux && osConfig.programs._1password-gui.enable)
              "${osConfig.programs._1password-gui.package}/bin/op-ssh-sign";
          };

          user.signingKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILgD7me/mlDG89ZE/tLTJeNhbo3L+pi7eahB2rUneSR4";
        };
      };
    };
  };
}
