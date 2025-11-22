{
  inputs,
  pkgs,
  lib,
  config,
  ...
}: {
  config = {
    assertions =
      builtins.map (
        n: let
          p = "${n.src}/${n.file}";
        in {
          message = "${n.name} doesnt exist (${p})";
          assertion = builtins.pathExists p;
        }
      )
      config.programs.zsh.plugins;

    programs = {
      zoxide.enable = true;
      zsh = {
        enable = true;
        enableAutosuggestions = true;
        enableVteIntegration = true;

        syntaxHighlighting = {
          enable = true;
        };

        dotDir = "${config.xdg.configHome}/zsh";

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
          docs = "${config.home.homeDirectory}/Documents";
          vids = "${config.home.homeDirectory}/Videos";
          dl = "${config.home.homeDirectory}/Downloads";
          dev = "${config.home.homeDirectory}/Developer";
          nix-conf = "${config.home.homeDirectory}/Developer/nix-config";
          media = "/run/media/tomas";
        };

        sessionVariables = {
          LESS = "-R";
          PAGER = "more";
        };
        envExtra = ''
          ZSH_CACHE_DIR="${config.xdg.cacheHome}/oh-my-zsh";
        '';

        #nixos-menu () {
        #  ${lib.getExe pkgs.custom.menu}
        #}
        #zle -N nixos-menu
        #bindkey '^A' nixos-menu
        initExtraBeforeCompInit = ''
          export HYPHEN_INSENSITIVE="true"
          zstyle ':completion:*:ssh:*' hosts off

          expand-or-complete-with-dots() {
            # use $COMPLETION_WAITING_DOTS either as toggle or as the sequence to show
            # [[ $COMPLETION_WAITING_DOTS = true ]] && COMPLETION_WAITING_DOTS="%F{red}…%f"
            # turn off line wrapping and print prompt-expanded "dot" sequence
            printf '\e[?7l%s\e[?7h' "%F{red}…%f"
            zle expand-or-complete
            zle redisplay
          }
          zle -N expand-or-complete-with-dots
          # Set the function as the default tab completion widget
          bindkey -M emacs "^I" expand-or-complete-with-dots
          bindkey -M viins "^I" expand-or-complete-with-dots
          bindkey -M vicmd "^I" expand-or-complete-with-dots
        '';

        initExtra = ''
          bindkey -M emacs -s '^A' 'menu^M'
          bindkey -M vicmd -s '^A' 'menu^M'
          bindkey -M viins -s '^A' 'menu^M'

          function zellij_refresh_ssh_sock {
            if [ -n "$ZELLIJ" ]; then
              if [ -e  ]; then
                export SSH_AUTH_SOCK="$HOME/.ssh/ssh_auth_sock"
              fi
            fi
          }

          add-zsh-hook precmd zellij_refresh_ssh_sock

          if [[ "$TTY" = /dev/tty* ]] ; then
            fbterm && exit
          fi

          function take() {
            mkdir -p $@ && cd ''${@:$#}
          }
        '';

        # initExtraFirst = ''
        #   source "${iterm}";
        # '';
        shellGlobalAliases = {
          "..." = "'../..'";
          "...." = "'../../..'";
          "....." = "'../../../..'";
          "......" = "'../../../../..'";
        };

        shellAliases = let
          silver = "-H 192.168.69.45 -U root -P \"$(op item get abrgfwmlbnc2zghpugawqoagjq --field password --reveal)\"";
          blue = "-H 192.168.69.46 -U ADMIN -P \"$(op item get ydq2vns3nc4hj43n4avtryckpa --field password --reveal)\"";
        in {
          silver-star-ipmi = "ipmitool -I lanplus ${silver}";
          blue-fire-ipmi = "ipmitool -I lanplus ${blue}";
          silver-star-console = "ipmiconsole ${silver}";
          blue-fire-console = "ipmiconsole ${blue}";

          "$" = "";
          ll = "ls -l";
          ls = "exa";
          la = "exa -a";
          grep = "grep --color=auto";
          cp = "cp -i";
          mv = "mv -i";
          rm = "rm -i";
          g = "git";
          gs = "git status";
          st = "systemctl-tui";
          #pvzst = "pv @1 -N in -B 500M -pterbT | zstd - -e -T4 | pv -N out -B 500M -pterbT > @2";
          cat = "bat";
          dig = "dog";
          yz = "yazi";
          ys = "yazi /sys";
          nob = "nh os build .";
          not = "nh os test .";
          nos = "nh os switch .";
          nobo = "nh os boot .";

          man = "batman";
          wget = "wget2";
          # silver-star-ipmi raw 0x30 0x30 0x01 0x00
          # silver-star-ipmi raw 0x30 0x30 0x02 0xff 0x10

          docker-login = "op item get raeclwvdys3epkmc5zthv4pdha --format=json --vault=qtvfhvfotoqynomh2wd3yzoofe | jq '.fields[1].value' -r | docker login ghcr.io --username tomasharkema --password-stdin";

          unifi-tui = "unifi-tui --insecure --url \"https://192.168.1.1/proxy/network/integrations\" --api-key \"$(op item get ojsyugyddrsxtq3kayoonibhda --reveal --field credential)\"";

          zellij = "systemd-run --scope --user zellij";

          # subl = (lib.mkIf pkgs.stdenv.isDarwin) "/Applications/Sublime\\ Text.app/Contents/SharedSupport/bin/subl";
        };

        plugins = with pkgs; let
          ohMyZshSource = inputs.ohmyzsh;
        in [
          {
            name = "sudo";
            file = "plugins/sudo/sudo.plugin.zsh";
            src = ohMyZshSource;
          }
          {
            name = "kitty";
            file = "plugins/kitty/kitty.plugin.zsh";
            src = ohMyZshSource;
          }
          {
            name = "websearch";
            file = "plugins/web-search/web-search.plugin.zsh";
            src = ohMyZshSource;
          }

          # {
          #   name = "termsupport";
          #   file = "lib/termsupport.zsh";
          #   src = ohMyZshSource;
          # }
          # {
          #   name = "1password";
          #   file = "plugins/1password/1password.plugin.zsh";
          #   src = ohMyZshSource;
          # }
          rec {
            name = src.pname;
            file = "share/zsh-z/zsh-z.plugin.zsh";
            src = zsh-z;
          }
          # rec {
          #   name = src.pname;          # dev = ''
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
          #   file = "share/zsh-bd/bd.plugin.zsh";
          #   src = zsh-bd;
          # }
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
          rec {
            name = src.pname;
            file = "share/zsh/zsh-forgit/forgit.plugin.zsh";
            src = zsh-forgit;
          }
          # rec {
          #   name = src.pname;
          #   file = "share/wd/wd.plugin.zsh";
          #   src = zsh-wd;
          # }
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
          # {
          #   name = "enhancd";
          #   file = "init.sh";
          #   src = pkgs.fetchFromGitHub {
          #     owner = "b4b4r07";
          #     repo = "enhancd";
          #     rev = "v2.2.1";
          #     sha256 = "0iqa9j09fwm6nj5rpip87x3hnvbbz9w9ajgm6wkrd5fls8fn8i5g";
          #   };
          # }
          {
            name = "zsh-async";
            file = "async.zsh";
            src = inputs.zsh-async;
          }
          {
            name = "complete-ng";
            file = "complete-ng.plugin.zsh";
            src = inputs.complete-ng;
          }
          {
            name = "zsh-colored-man-pages";
            file = "colored-man-pages.plugin.zsh";
            src = inputs.zsh-colored-man-pages;
          }
          {
            name = "zsh-tab-title";
            file = "zsh-tab-title.plugin.zsh";
            src = inputs.zsh-tab-title;
          }
          {
            name = "zsh-smartinput";
            file = "smartinput.plugin.zsh";
            src = inputs.zsh-smartinput;
          }
        ];
      };
    };
  };
}
