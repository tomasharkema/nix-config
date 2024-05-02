{
  inputs,
  config,
  lib,
  pkgs,
  osConfig,
  ...
}: let
  inherit (pkgs) stdenv;

  bgGenerate = name: srcc:
    stdenv.mkDerivation {
      name = "png-${name}.png";

      phases = ["buildPhase"];
      buildInputs = with pkgs; [imagemagick];

      buildPhase = ''
        touch $out
        convert -density 1536 -background none -size 3840x2160 ${srcc} $out
      '';
    };

  iterm = pkgs.fetchurl {
    url = "https://iterm2.com/shell_integration/zsh";
    sha256 = "sha256-Cq8winA/tcnnVblDTW2n1k/olN3DONEfXrzYNkufZvY=";
  };
  bg = pkgs.fetchurl {
    url = "https://gitlab.gnome.org/GNOME/gnome-backgrounds/-/raw/main/backgrounds/blobs-d.svg";
    sha256 = "sha256-IG9BGCOXTD5RtBZOCnC/CJnjUtqJcoz+gijlMscrnEY=";
  };
  bgLight = pkgs.fetchurl {
    url = "https://gitlab.gnome.org/GNOME/gnome-backgrounds/-/raw/main/backgrounds/blobs-l.svg";
    sha256 = "sha256-zVNMDAgfZvEwPHbhJ0/NBSNseNjIF+jxD3K2zcSj36U=";
  };
  bgPng = bgGenerate "bg" bg;
  bgLightPng = bgGenerate "bgLight" bgLight;
in
  with lib; {
    imports = [
    ];

    config = {
      programs.inshellisense = {
        enable = true;
        # enableZshIntegration = true;
      };
      xdg = mkIf pkgs.stdenv.isLinux {
        userDirs = {
          enable = true;
          extraConfig = {
            XDG_DEV_DIR = "${config.home.homeDirectory}/Developer";
          };
        };
      };
      dconf.settings = {
        "org/gnome/desktop/background" = {
          picture-uri = "file://${bg}";
          picture-uri-dark = "file://${bg}";
        };
      };
      home = {
        file =
          osConfig.home.homeFiles
          // {
            ".face" = {
              source = pkgs.fetchurl {
                url = "https://avatars.githubusercontent.com/u/4534203?t=1";
                sha256 = "sha256:1g4mrz2d8h13rp8z2b9cn1wdr4la5zzrfkqgblayb56zg7706ga6";
              };
            };
            ".background-image.svg".source = "${bg}";
            ".background-image".source = "${bg}";
            ".background-image.png".source = "${bgPng}";
            ".background-image-light.png".source = "${bgLightPng}";
            # "wp.jpg" = {
            #   source = builtins.fetchurl {
            #     url = "https://t.ly/n3kq7";
            #     sha256 = "sha256:0p9lyarqw63b1npicc5ps8h6c34n1137f7i6qz3jrcxg550girh0";
            #   };
            # };
            # "wp.png" = {
            #   source = builtins.fetchurl {
            #     url = "https://t.ly/r76YX";
            #     sha256 = "sha256:0g4a6a5yy4mdlqkvw3lc02wgp4hmlvj0nc8lvlgigkra95jq9x3x";
            #   };
            # };
            # ".config/cachix/cachix.dhall".source = config.lib.file.mkOutOfStoreSymlink "/etc/cachix.dhall"; # osConfig.age.secrets.cachix.path;
            # ".config/notify/provider-config.yaml".source = osConfig.age.secrets.notify.path;
            # "${config.xdg.dataHome}/Zeal/Zeal/docsets/nixpkgs.docset" = {
            #   # /nixpkgs.docset" = {
            #   source = config.lib.file.mkOutOfStoreSymlink "${pkgs.custom.nixpkgs-docset}/nixpkgs.docset";
            #   recursive = true;
            # };
            ".local/share/flatpak/overrides/global" = mkIf stdenv.isLinux {
              text = ''
                [Context]
                filesystems=/run/current-system/sw/share/X11/fonts:ro;/nix/store:ro;/home/tomas/.local/share/fonts:ro;/home/tomas/.config/gtk-4.0:ro;/home/tomas/.config/gtk-3.0:ro;
              '';
            };
          };
        activation = {
          userSymlinks-fonts = mkIf (stdenv.isLinux && osConfig.gui.enable) ''
            ln -sfn /run/current-system/sw/share/X11/fonts ~/.local/share/fonts
          '';

          # userSymlinks-cachix = ''
          #   if [ ! -d "$HOME/.config/cachix" ]; then
          #     mkdir $HOME/.config/cachix
          #   fi
          #   ln -sfn /etc/cachix.dhall $HOME/.config/cachix/cachix.dhall
          # '';
          userSymlinks-notify = mkIf osConfig.gui.enable ''
            if [ ! -d "$HOME/.config/notify" ]; then
              mkdir $HOME/.config/notify
            fi
            ln -sfn "${osConfig.age.secrets.notify.path}" ~/.config/notify/provider-config.yaml
          '';
        };

        stateVersion = "23.11";

        # (import ./packages/common.nix {inherit pkgs inputs lib;})
        # ++
        packages = with pkgs; [
          fup-repl
          udict
          #pkgs.custom.b612
          b612
          # rtfm
          jq
          # fig
          # kitty-img
          # todoman
          # dooit
          ttdl
          topydo
        ];
        sessionVariables =
          if stdenv.isDarwin
          then {
            EDITOR = "subl";
            SSH_AUTH_SOCK = "/Users/tomas/.1password/agent.sock";
            # SPACESHIP_PROMPT_ADD_NEWLINE = "false";
          }
          else {
            EDITOR = "nvim";
            # SSH_AUTH_SOCK = "/home/tomas/.1password/agent.sock";
          };
      };

      fonts.fontconfig.enable = true;

      autostart.programs = with pkgs; mkIf osConfig.gui.enable [telegram-desktop trayscale];

      programs = {
        home-manager.enable = true;

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

        atuin = {
          enable = true;
          enableZshIntegration = true;
          settings = {
            key_path = osConfig.age.secrets.atuin.path;
            # sync_address = "https://atuin.harke.ma";
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
            directory = {
              fish_style_pwd_dir_length = 2;
            };
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

          initExtra = ''
            #nixos-menu () {
            #  ${lib.getExe pkgs.custom.menu}
            #}
            #zle -N nixos-menu
            #bindkey '^A' nixos-menu

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

            wget2 = "${pkgs.wget2}";

            # silver-star-ipmi raw 0x30 0x30 0x01 0x00
            # silver-star-ipmi raw 0x30 0x30 0x02 0xff 0x10
            silver-star-ipmi = "ipmitool -I lanplus -H 192.168.0.45 -U root -P \"$(op item get abrgfwmlbnc2zghpugawqoagjq --field password)\"";

            dockerlogin = "op item get raeclwvdys3epkmc5zthv4pdha --format=json --vault=qtvfhvfotoqynomh2wd3yzoofe | jq '.fields[1].value' -r | docker login ghcr.io --username tomasharkema --password-stdin";

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

          zplug = {
            enable = true;
            plugins = [
              {
                name = "marzocchi/zsh-notify";
              }
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
            ];
          };

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
