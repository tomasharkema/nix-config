{
  pkgs,
  lib,
  config,
  ...
}: {
  config = {
    assertions =
      builtins.map (n: let
        p = "${n.src}/${n.file}";
      in {
        message = "${n.name} doesnt exist (${p})";
        assertion = builtins.pathExists p;
      })
      config.programs.zsh.plugins;

    # home.packages = builtins.map (n: n.src) config.programs.zsh.plugins;
    # home.packages = with pkgs; [
    # jupyter
    # ];

    programs = {
      zoxide.enable = true;
      zsh = {
        enable = true;
        enableAutosuggestions = true;
        syntaxHighlighting.enable = true;
        enableVteIntegration = true;
        enableSyntaxHighlighting = true;

        dotDir = ".config/zsh";

        autocd = true;

        history = {
          extended = true;
          expireDuplicatesFirst = true;
        };

        historySubstringSearch = {
          enable = true;
          # searchUpKey = "^[OA";
          # searchDownKey = "^[OB";
        };

        dirHashes = {
          docs = "$HOME/Documents";
          vids = "$HOME/Videos";
          dl = "$HOME/Downloads";
          dev = "$HOME/Developer";
          nix-conf = "$HOME/Developer/nix-config";
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

          subl = (lib.mkIf pkgs.stdenv.isDarwin) "/Applications/Sublime\\ Text.app/Contents/SharedSupport/bin/subl";
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

        plugins = with pkgs; [
          rec {
            name = "you-should-use";
            file = "share/zsh/plugins/you-should-use/you-should-use.plugin.zsh";
            src = zsh-you-should-use;
          }
          rec {
            name = src.pname;
            file = "share/zsh-z/zsh-z.plugin.zsh";
            src = zsh-z;
          }
          rec {
            name = src.pname;
            file = "share/zsh-bd/bd.plugin.zsh";
            src = zsh-bd;
          }
          rec {
            name = src.pname;
            file = "share/zsh-defer/zsh-defer.plugin.zsh";
            src = zsh-defer;
          }
          rec {
            name = src.pname;
            file = "share/zsh/zsh-edit/zsh-edit.plugin.zsh";
            src = zsh-edit;
          }
          # rec {
          #   name = src.pname;
          #   file = "share/zsh/zsh-abbr/abbr.plugin.zsh";
          #   src = zsh-abbr;
          # }
          rec {
            name = src.pname;
            file = "share/zsh/zsh-forgit/forgit.plugin.zsh";
            src = zsh-forgit;
          }
          rec {
            name = src.pname;
            file = "share/wd/wd.plugin.zsh";
            src = zsh-wd;
          }
          rec {
            name = src.pname;
            file = "share/zsh-nix-shell/nix-shell.plugin.zsh";
            src = zsh-nix-shell;
          }
          rec {
            name = src.pname;
            file = "share/zsh/plugins/command-time/command-time.plugin.zsh";
            src = zsh-command-time;
          }
          rec {
            name = src.pname;
            file = "share/zsh/plugins/nix/nix.plugin.zsh";
            src = nix-zsh-completions;
          }
          {
            name = "enhancd";
            file = "init.sh";
            src = pkgs.fetchFromGitHub {
              owner = "b4b4r07";
              repo = "enhancd";
              rev = "v2.2.1";
              sha256 = "0iqa9j09fwm6nj5rpip87x3hnvbbz9w9ajgm6wkrd5fls8fn8i5g";
            };
          }
          {
            name = "zsh-async";
            file = "async.zsh";
            src = pkgs.fetchgit {
              url = "https://github.com/mafredri/zsh-async";
              rev = "bbbc92bd01592513a6b7739a45b7911af18acaef";
              hash = "sha256-mpXT3Hoz0ptVOgFMBCuJa0EPkqP4wZLvr81+1uHDlCc=";
            };
          }
          {
            name = "zsh-colored-man-pages";
            file = "colored-man-pages.plugin.zsh";
            src = pkgs.fetchgit {
              url = "https://github.com/ael-code/zsh-colored-man-pages";
              rev = "57bdda68e52a09075352b18fa3ca21abd31df4cb";
              hash = "sha256-087bNmB5gDUKoSriHIjXOVZiUG5+Dy9qv3D69E8GBhs=";
            };
          }
        ];

        oh-my-zsh = {
          enable = true;
          extraConfig = ''
            ZSH_WEB_SEARCH_ENGINES=(nix-package "https://search.nixos.org/packages?query=" nix-option "https://search.nixos.org/options?query=")
            COMPLETION_WAITING_DOTS=true
            HYPHEN_INSENSITIVE=true
          '';
          plugins =
            [
              # "you-should-use"
              "1password"
              "autojump"
              "aws"
              "battery"
              "bgnotify"
              "colorize"
              "common-aliases"
              "copybuffer"
              "copyfile"
              "copypath"
              "cp"
              # "direnv"
              "dirhistory"
              "dirpersist"
              "dotnet"
              "emoji"
              "encode64"
              "extract"
              "fastfile"
              "fig"
              "fzf"
              "gh"
              "git-auto-fetch"
              "git-extras"
              "git-prompt"
              "git"
              "github"
              "gitignore"
              "golang"
              "history-substring-search"
              "history"
              "iterm2"
              "jira"
              "jsontools"
              "kitty"
              "man"
              "mix"
              "nmap"
              "perms"
              "safe-paste"
              "screen"
              "shrink-path"
              "ssh"
              "sublime-merge"
              "sublime"
              "sudo"
              "swiftpm"
              "systemadmin"
              "tailscale"
              "thefuck"
              "tig"
              "tmux"
              "tldr"
              "torrent"
              "transfer"
              "universalarchive"
              "urltools"
              "vi-mode"
              "vscode"
              "wakeonlan"
              "wd"
              "wd"
              "web-search"
              "yarn"
              "z"
              "zoxide"
              "zsh-interactive-cd"
              "zsh-navigation-tools"
              # "docker"
              # "iterm-tab-color"
            ]
            ++ (lib.optionals pkgs.stdenv.isDarwin [
              "brew"
              "dash"
              "macos"
              "pod"
              "xcode"
            ])
            ++ (lib.optionals pkgs.stdenv.isLinux [
              "systemd"
              "firewalld"
            ]);
          #   # theme = "powerlevel10k/powerlevel10k";
        };
      };
    };
  };
}
