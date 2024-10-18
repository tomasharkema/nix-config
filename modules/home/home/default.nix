{
  inputs,
  config,
  lib,
  pkgs,
  osConfig,
  ...
}: let
  iterm = pkgs.fetchurl {
    url = "https://iterm2.com/shell_integration/zsh";
    sha256 = "sha256-Cq8winA/tcnnVblDTW2n1k/olN3DONEfXrzYNkufZvY=";
  };
  itermCatppuccin = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "iterm";
    rev = "6b5765b3d701fb21e6c250fcd0d90bc65e50d031";
    hash = "sha256-gB3ItHv2y8zE/xlBmkVvw33WIAVLMYiLsU2jpmT23DY=";
  };
  # bg = pkgs.fetchurl {
  #   url =
  #     "https://gitlab.gnome.org/GNOME/gnome-backgrounds/-/raw/main/backgrounds/blobs-d.svg";
  #   sha256 = "sha256-IG9BGCOXTD5RtBZOCnC/CJnjUtqJcoz+gijlMscrnEY=";
  # };
  # bgLight = pkgs.fetchurl {
  #   url =
  #     "https://gitlab.gnome.org/GNOME/gnome-backgrounds/-/raw/main/backgrounds/blobs-l.svg";
  #   sha256 = "sha256-zVNMDAgfZvEwPHbhJ0/NBSNseNjIF+jxD3K2zcSj36U=";
  # };
  # aicommits = pkgs.writeShellScriptBin "aicommits" ''
  #   OPENAI_API_KEY="$(${pkgs._1password}/bin/op item get 2vzrjmprwi25zts7mzb4zmmad4 --field credential)"
  #   aicommits config set OPENAI_KEY=$OPENAI_API_KEY
  #   exec ${pkgs.custom.aicommits}/bin/aicommits "$@"
  # '';
  # gptcommit-wrap = pkgs.writeShellScriptBin "gptcommit" ''
  #   GPTCOMMIT__OPENAI__API_KEY="$(${pkgs._1password}/bin/op item get 2vzrjmprwi25zts7mzb4zmmad4 --field credential)"
  #   exec ${lib.getExe pkgs.gptcommit}
  # '';
in {
  imports = [];

  config = {
    services.lorri = lib.mkIf pkgs.stdenv.isLinux {
      enable = true;

      enableNotifications = true;
    };

    programs.inshellisense = {
      enable = true;
      enableZshIntegration = true;
    };

    xdg = lib.mkIf pkgs.stdenv.isLinux {
      systemDirs.data = [
        "/run/opengl-driver/share"
      ];
    };

    home = {
      file = {"itermCatppuccin".source = itermCatppuccin;} // osConfig.home.homeFiles;

      stateVersion = "24.11";

      # (import ./packages/common.nix {inherit pkgs inputs lib;})
      # ++
      packages = with pkgs;
        [
          lrzsz
          devcontainer
          # picotool
          newman
          # postman
          atac
          # httpie-desktop
          nix-htop
          augeas
          custom.bieye
          wget2
          libnotify
          trippy
          fup-repl
          # gptcommit-wrap

          udict
          # rtfm
          jq
          # fig
          # kitty-img
          # todoman
          # dooit
          ttdl
          topydo
          jqp
          # nchat
          git-agecrypt
          projectable
          # xplr
          lazycli
          # f1viewer
          # aicommits
          openai
        ]
        ++ (lib.optionals pkgs.stdenv.isx86_64 [
          valgrind
        ]);

      activation."agent-1password" = lib.mkIf pkgs.stdenv.hostPlatform.isDarwin (inputs.home-manager.lib.hm.dag.entryAfter ["writeBoundary"] ''
        mkdir -p "/Users/${osConfig.user.name}/.1password" || true
        ln -sfn "/Users/${osConfig.user.name}/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock" "/Users/${osConfig.user.name}/.1password/agent.sock"
      '');

      sessionVariables = (
        if pkgs.stdenv.hostPlatform.isDarwin
        then {
          EDITOR = "subl";
          # SSH_AUTH_SOCK = "/Users/${osConfig.user.name}/.1password/agent.sock";
          SSH_AUTH_SOCK = "/Users/${osConfig.user.name}/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh";
          # SPACESHIP_PROMPT_ADD_NEWLINE = "false";
        }
        else {
          # EDITOR = "nvim";
        }
      );
    };

    fonts.fontconfig.enable = true;

    programs = {
      # freetube.enable = true;

      home-manager.enable = true;

      nix-index-database.comma.enable = true;

      # termite.enable = osConfig.gui.enable;
      # terminator.enable = lib.mkIf pkgs.stdenv.isLinux osConfig.gui.enable;

      yt-dlp.enable = true;

      direnv = {
        enable = true;
        nix-direnv.enable = true;
      };

      vscode = lib.mkIf pkgs.stdenv.isLinux {
        enable = true;
        package = pkgs.vscode.fhs;
      };

      htop = {
        enable = true;
        package = pkgs.htop;
        settings = {
          show_program_path = false;
          hide_kernel_threads = true;
          hide_userland_threads = true;
          show_cpu_frequency = true;
          show_cpu_temperature = true;
        };
      };

      autojump = {
        enable = true;
        enableZshIntegration = true;
      };

      broot = {
        enable = true;
        enableZshIntegration = true;
      };

      fzf = {
        enable = true;
        enableZshIntegration = true;
      };

      thefuck = {
        enable = true;
        enableZshIntegration = true;
      };

      tmux = {enable = true;};

      alacritty.enable = osConfig.gui.enable;

      # bat = {
      #   enable = true;
      #   config.theme = "base16";
      #   themes.base16.src = pkgs.writeText "base16.tmTheme" osConfig.variables.theme.tmTheme;
      # };

      lsd.enable = true;
      jq.enable = true;
      skim.enable = true;

      starship = {
        enable = true;
        enableZshIntegration = true;
        settings = {
          gcloud.disabled = true;
          nix_shell.disabled = false;

          hostname.disabled = false;

          sudo.disabled = false;
          shell.disabled = false;
          os.disabled = false;

          # cmd_duration.min_time = 1000;
          # command_timeout = 1000;
          memory_usage.disabled = false;
          directory = {fish_style_pwd_dir_length = 2;};
          # add_newline = false;
        };
      };
    };
  };
}
