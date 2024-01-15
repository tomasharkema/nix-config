{
  config,
  lib,
  pkgs,
  osConfig,
  ...
}: let
  inherit (pkgs) stdenv;
  iterm = pkgs.fetchurl {
    url = "https://iterm2.com/shell_integration/zsh";
    sha256 = "sha256-Cq8winA/tcnnVblDTW2n1k/olN3DONEfXrzYNkufZvY=";
  };
in {
  # imports = [../../nixos/gui/gnome/dconf.nix];

  config = {
    home = {
      file = {
        ".config/cachix/cachix.dhall".source = config.lib.file.mkOutOfStoreSymlink "/etc/cachix.dhall"; # osConfig.age.secrets.cachix.path;
      };

      stateVersion = "23.11";

      # (import ./packages/common.nix {inherit pkgs inputs lib;})
      # ++
      packages = with pkgs; [
        b612
        (
          nerdfonts.override {
            fonts = [
              "FiraCode"
              "FiraMono"
              "DroidSansMono"
              "3270"
              "Agave"
              "BigBlueTerminal"
              # "OpenDyslectic"
              "ComicShannsMono"
              "JetBrainsMono"
              # "B612Mono"
              # "0xProto"
              # "LeagueMono"
              # "CodeNewRomanNerdFont"
            ];
          }
        )
        jq
        # fig
        # inputs.nix-gui.packages.${system}.nix-gui
      ];
      sessionVariables = lib.mkIf stdenv.isDarwin {
        EDITOR = "subl";
        SSH_AUTH_SOCK = "/Users/tomas/.1password/agent.sock";
        SPACESHIP_PROMPT_ADD_NEWLINE = "false";
      };
    };
    manual = {
      html.enable = false;
      manpages.enable = false;
      json.enable = false;
    };
    # home.username = lib.mkDefault "tomas";
    # home.homeDirectory = lib.mkDefault (home-directory "tomas");

    # age.identityPaths = [
    #   "/etc/ssh/ssh_host_ed25519_key"
    #   "${config.home.homeDirectory}/.ssh/id_ed25519"
    #   "${config.home.homeDirectory}/.ssh/id_rsa"
    # ];

    # nixpkgs.config.allowUnfreePredicate = _: true;
    # nixpkgs.config.allowUnfree = true;

    age.secrets."cachix-activate" = {
      file = ../../../secrets/cachix-activate.age;
    };

    fonts.fontconfig.enable = true;

    programs = {
      home-manager.enable = true;
      kitty = {
        enable = true;
        theme = "Catppuccin-Mocha";
        settings = {
          font_family = "JetBrainsMono Nerd Font Mono Regular";
          font_size = "12.0";
        };
        shellIntegration = {
          enableZshIntegration = true;
        };
      };

      termite.enable = true;
      terminator.enable = lib.mkIf pkgs.stdenv.isLinux true;
      yt-dlp.enable = true;

      direnv = {
        enable = true;
        nix-direnv.enable = true;
      };

      htop = {
        enable = true;
        settings.show_program_path = false;
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

      atuin = {
        enable = true;
        enableZshIntegration = true;
        settings = {
          key_path = "/tmp/atuin.key";
          sync_address = "https://atuin.harke.ma";
          auto_sync = true;
          sync_frequency = "10m";
          workspaces = true;
          style = "compact";
          secrets_filter = true;
          common_subcommands = [
            "cargo"
            "go"
            "git"
            "npm"
            "yarn"
            "pnpm"
            "kubectl"
            "nix"
            "nom"
          ];
        };
      };

      git = {
        enable = true;
        userName = "Tomas Harkema";
        userEmail = "tomas@harkema.io";
      };

      lazygit.enable = true;
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
          directory = {
            fish_style_pwd_dir_length = 2;
          };
          add_newline = false;
        };
      };

      gh-dash.enable = true;
      zsh = {
        enable = true;
        enableAutosuggestions = true;
        syntaxHighlighting.enable = true;
        enableVteIntegration = true;
        enableSyntaxHighlighting = true;

        autocd = true;

        history.extended = true;
        history.expireDuplicatesFirst = true;
        historySubstringSearch = {
          enable = true;
          # searchUpKey = "^[OA";
          # searchDownKey = "^[OB";
        };

        plugins = [
          {
            name = "zsh-nix-shell";
            file = "nix-shell.plugin.zsh";
            src = pkgs.fetchFromGitHub {
              owner = "chisui";
              repo = "zsh-nix-shell";
              rev = "v0.4.0";
              sha256 = "037wz9fqmx0ngcwl9az55fgkipb745rymznxnssr3rx9irb6apzg";
            };
          }
        ];

        initExtraFirst = ''
          #       zmodload zsh/zprof
          #       # eval "$(~/.local/bin/cw init zsh pre)"
          source "${iterm}";
        '';
        # initExtra = ''
        #   # eval "$(~/.local/bin/cw init zsh post)"
        # '';

        shellAliases = {
          ll = "ls -l";
          ls = "exa";
          la = "exa -a";
          grep = "grep --color=auto";
          cp = "cp -i";
          mv = "mv -i";
          rm = "rm -i";
          g = "git";
          gs = "git status";
          pvxz = "pv @1 -N in -B 500M -pterbT | xz -e9 -T4 | pv -N out -B 500M -pterbT > @2";
          cat = "bat";
          dig = "dog";
          ap = "attic push tomas:tomas";
          cap = "cachix push tomasharkema";
          # subl = (lib.mkIf stdenv.isDarwin) "/Applications/Sublime\\ Text.app/Contents/SharedSupport/bin/subl";
          # dev = ''
          #   nix develop --profile dev-profile -c true && \
          #     cachix push tomasharkema dev-profile && \
          #     exec nix develop --profile dev-profile
          # '';
          # updatehome = ''
          #   nix build ~/Developer/nix-config#homeConfigurations."tomas@$(hostname)".activationPackage --json \
          #     | jq -r '.[].outputs | to_entries[].value' \
          #     | cachix push tomasharkema
          # '';
          # upload-to-cache = ''
          #   set -eu; \
          #   set -f ; \
          #   export IFS=' ' ; \
          #   echo "Signing and uploading paths" $OUT_PATHS ; \
          #   exec nix copy --to 'http://silver-star.ling-lizard.ts.net:6666/' $OUT_PATHS'';

          # upload-after-build = ''
          #   jq -r '.[].outputs | to_entries[].value' | nix copy --to 'https://nix-cache.harke.ma' --stdin
          # '';
        };

        prezto = {
          enable = true;

          pmodules = [
            "osx"
            "homebrew"
            "environment"
            "terminal"
            "git"
            "editor"
            "tmux"
            "fasd"
            "history"
            "history-substring-search"
            "directory"
            "spectrum"
            "utility"
            #"completion"
            #"autosuggestions"
            # "prompt"
            "rsync"
            "archive"
            "docker"
            #"syntax-highlighting"
          ];

          caseSensitive = false;
          editor.dotExpansion = true;
          terminal.autoTitle = true;

          tmux = {
            autoStartRemote = true;
            itermIntegration = true;
            # autoStartLocal = true;
          };

          prompt.pwdLength = "short";
          utility.safeOps = true;
          prompt.theme = null;
        };

        # zplug = {
        #   enable = true;
        #   plugins = [
        #     # {
        #     #   name = "tysonwolker/iterm-tab-colors";
        #     #   tags = ["defer:2"];
        #     # }
        #     {
        #       name = "mafredri/zsh-async";
        #       # tags = ["defer:2"];
        #     }
        #     {
        #       name = "MichaelAquilina/zsh-you-should-use";
        #       tags = ["defer:2"];
        #     }
        #     {
        #       name = "unixorn/1password-op.plugin.zsh";
        #       tags = ["defer:2"];
        #     }
        #     # {name = "mrjohannchang/zsh-interactive-cd";}
        #   ];
        # };

        oh-my-zsh = {
          enable = true;
          plugins = [
            "1password"
            "autojump"
            "aws"
            "colorize"
            "docker"
            "encode64"
            "fzf"
            "git-extras"
            "git"
            "gitignore"
            "macos"
            "man"
            "mix"
            "nmap"
            "sudo"
            "systemd"
            "thefuck"
            "tig"
            "tmux"
            "vi-mode"
            "yarn"
            "zsh-navigation-tools"
            "wd"
            "tmux"
            # "iterm-tab-color"
          ];
          #   # theme = "powerlevel10k/powerlevel10k";
        };
      };
    };
  };
}
