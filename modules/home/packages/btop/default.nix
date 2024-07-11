{
  pkgs,
  lib,
  ...
}: {
  config = {
    programs.btop = {
      enable = true;
      package = pkgs.unstable.btop;
      settings = {proc_per_core = true;};
    };

    home.file = {
      # ".config/btop/themes" = {
      #   source = pkgs.fetchFromGitHub {
      #     owner = "catppuccin";
      #     repo = "btop";
      #     rev = "c6469190f2ecf25f017d6120bf4e050e6b1d17af";
      #     hash = "sha256-jodJl4f2T9ViNqsY9fk8IV62CrpC5hy7WK3aRpu70Cs=";
      #   };
      # };
    };
  };
}
