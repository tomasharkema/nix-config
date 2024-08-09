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
in
  with lib; {
    imports = [];

    config = {
      services.lorri = mkIf pkgs.stdenv.isLinux {
        enable = true;

        enableNotifications = true;
      };

      programs.inshellisense = {
        # enable = true;
        # enableZshIntegration = true;
      };

      home = {
        # file = osConfig.home.homeFiles;
        stateVersion = "24.05";

        # (import ./packages/common.nix {inherit pkgs inputs lib;})
        # ++
        packages = with pkgs; [
          newman
          postman
          atac
          httpie-desktop
          nix-htop
          augeas
          custom.bieye
          wget2
          libnotify

          # fup-repl
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
          xplr
          lazycli
          f1viewer
          # aicommits
          openai
        ];
        sessionVariables =
          if pkgs.stdenv.hostPlatform.isDarwin
          then {
            EDITOR = "subl";
            SSH_AUTH_SOCK = "/Users/tomas/.1password/agent.sock";
            # SPACESHIP_PROMPT_ADD_NEWLINE = "false";
          }
          else {
            # EDITOR = "nvim";
          };
      };

      fonts.fontconfig.enable = true;

      programs = {
        freetube.enable = true;

        home-manager.enable = true;

        nix-index-database.comma.enable = true;

        # termite.enable = osConfig.gui.enable;
        # terminator.enable = lib.mkIf pkgs.stdenv.isLinux osConfig.gui.enable;

        yt-dlp.enable = true;

        direnv = {
          enable = true;
          nix-direnv.enable = true;
        };

        # vscode = {
        #   enable = true;
        # };

        htop = {
          enable = true;
          package = pkgs.unstable.htop;
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

        # alacritty.enable = osConfig.gui.enable;

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

          #nixos-menu () {
          #  ${lib.getExe pkgs.custom.menu}
          #}
          #zle -N nixos-menu
          #bindkey '^A' nixos-menu

          initExtra = ''
            bindkey -M emacs -s '^A' 'menu^M'
            bindkey -M vicmd -s '^A' 'menu^M'
            bindkey -M viins -s '^A' 'menu^M'
          '';

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
            {
              name = "zsh-notify";
              file = "notify.plugin.zsh";
              src = pkgs.fetchFromGitHub {
                owner = "marzocchi";
                repo = "zsh-notify";
                rev = "9c1dac81a48ec85d742ebf236172b4d92aab2f3f";
                hash = "sha256-ovmnl+V1B7J/yav0ep4qVqlZOD3Ex8sfrkC92dXPLFI=";
              };
            }
          ];

          # initExtraFirst = ''
          #   source "${iterm}";
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
            pvzst = "pv @1 -N in -B 500M -pterbT | zstd - -e -T4 | pv -N out -B 500M -pterbT > @2";
            cat = "bat";
            dig = "dog";

            # silver-star-ipmi raw 0x30 0x30 0x01 0x00
            # silver-star-ipmi raw 0x30 0x30 0x02 0xff 0x10
            silver-star-ipmi = ''
              ipmitool -I lanplus -H 192.168.0.45 -U root -P "$(op item get abrgfwmlbnc2zghpugawqoagjq --field password)"'';

            blue-fire-ipmi = ''
              ipmitool -I lanplus -H 192.168.0.46 -U ADMIN -P "$(op item get ydq2vns3nc4hj43n4avtryckpa --field password)"'';

            docker-login = "op item get raeclwvdys3epkmc5zthv4pdha --format=json --vault=qtvfhvfotoqynomh2wd3yzoofe | jq '.fields[1].value' -r | docker login ghcr.io --username tomasharkema --password-stdin";

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
            enable = false;

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
              # autoStartRemote = true;
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
          #     {
          #       name = "marzocchi/zsh-notify";
          #     }
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
          # ];
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
