{
  pkgs,
  lib,
  config,
  ...
}: {
  config = {
    programs = {
      zoxide.enable = true;
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

        dirHashes = {};

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
            name = src.pname;
            src = zsh-you-should-use;
          }
          rec {
            name = src.pname;
            src = zsh-z;
          }
          rec {
            name = src.pname;
            src = zsh-bd;
          }
          rec {
            name = src.pname;
            src = zsh-defer;
          }
          rec {
            name = src.pname;
            src = zsh-edit;
          }
          rec {
            name = src.pname;
            src = zsh-abbr;
          }
          rec {
            name = src.pname;
            src = zsh-forgit;
          }
          rec {
            name = src.pname;
            src = zsh-wd;
          }
          rec {
            name = src.pname;
            src = zsh-nix-shell;
          }
          rec {
            name = src.pname;
            src = zsh-command-time;
          }
          rec {
            name = src.pname;
            src = zsh-navigation-tools;
          }
          rec {
            name = src.pname;
            src = nix-zsh-completions;
          }

          {
            name = "zsh-async";
            file = "async.zsh";
            src = builtins.fetchGit {
              url = "https://github.com/mafredri/zsh-async";
              rev = "bbbc92bd01592513a6b7739a45b7911af18acaef";
            };
          }
          {
            name = "zsh-colored-man-pages";
            file = "colored-man-pages.plugin.zsh";
            src = builtins.fetchGit {
              url = "https://github.com/ael-code/zsh-colored-man-pages";
              rev = "57bdda68e52a09075352b18fa3ca21abd31df4cb";
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
              "you-should-use"
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
              "direnv"
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
