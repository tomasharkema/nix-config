{
  inputs,
  config,
  pkgs,
  lib,
  hostname,
  ...
} @ attrs: let
  inherit (pkgs) stdenv;

  # tmux-menu = pkgs.writeShellScriptBin "tmux-menu" ''
  #   # Get a list of existing tmux sessions:
  #   TMUX_SESSIONS=$(tmux ls | awk -F: '{print $1}')

  #   # If there are no existing sessions:
  #   if [[ -z $TMUX_SESSIONS ]]; then
  #       echo "No existing tmux sessions. Creating a new session called 'default'..."
  #       tmux new -s default
  #   else
  #       # Present a menu to the user:
  #       echo "Existing tmux sessions:"
  #       echo "$TMUX_SESSIONS"
  #       echo "Enter the name of the session you want to attach to, or 'new' to create a new session: "
  #       read user_input

  #       # Attach to the chosen session, or create a new one:
  #       if [[ $user_input == "new" ]]; then
  #           echo "Enter name for new session: "
  #           read new_session_name
  #           tmux new -s $new_session_name
  #       else
  #           tmux attach -t $user_input
  #       fi
  #   fi
  # '';

  iterm = pkgs.fetchurl {
    url = "https://iterm2.com/shell_integration/zsh";
    sha256 = "sha256-Cq8winA/tcnnVblDTW2n1k/olN3DONEfXrzYNkufZvY=";
  };
  direnv = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/nix-community/nix-direnv/3.0.3/direnvrc";
    sha256 = "sha256-0EVQVNSRQWsln+rgPW3mXVmnF5sfcmKEYOmOSfLYxHg=";
  };
in {
  # nix.settings = {
  #   extra-experimental-features = "nix-command flakes";
  #   # distributedBuilds = true;
  #   trusted-users = [ "root" "tomas" ];
  #   extra-substituters = [
  #     # "ssh://nix-ssh@silver-star.ling-lizard.ts.net"
  #     "https://nix-cache.harke.ma/"
  #     "https://tomasharkema.cachix.org/"
  #     "https://cache.nixos.org/"
  #   ];
  #   extra-binary-caches = [
  #     "https://nix-cache.harke.ma/"
  #     "https://tomasharkema.cachix.org/"
  #     "https://cache.nixos.org/"
  #   ];
  #   extra-trusted-public-keys = [
  #     "silver-star.ling-lizard.ts.net:MBxJ2O32x6IcWJadxdP42YGVw2eW2tAbMp85Ws6QCno="
  #     "tomasharkema.cachix.org-1:LOeGvH7jlA3vZmW9+gHyw0BDd1C8a0xrQSl9WHHTRuA="
  #   ];
  #   access-tokens = [ "github.com=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" ];
  # };

  imports = [
    ./apps/tmux
    inputs.nix-index-database.hmModules.nix-index
    ./apps/keybase
    ./apps/gnome/dconf.nix
  ];

  # self.home-manager.backupFileExtension = "bak";
  home.packages = with pkgs;
    (import ./packages/common.nix attrs)
    ++ [(nerdfonts.override {fonts = ["FiraCode" "DroidSansMono"];})]
    ++ [
      nixd
      # fig
    ];

  home.username = lib.mkDefault "tomas";
  home.homeDirectory = lib.mkDefault "/home/tomas";

  home.stateVersion = "23.11";
  programs.home-manager.enable = true;
  home.sessionVariables = lib.mkIf stdenv.isDarwin {
    EDITOR = "subl";
    SSH_AUTH_SOCK = "/Users/tomas/.1password/agent.sock";
    SPACESHIP_PROMPT_ADD_NEWLINE = "false";
  };
  age.identityPaths = [
    "/etc/ssh/ssh_host_ed25519_key"
    "${config.home.homeDirectory}/.ssh/id_ed25519"
    # "${config.home.homeDirectory}/.ssh/id_rsa"
  ];

  nixpkgs.config.allowUnfreePredicate = _: true;
  nixpkgs.config.allowUnfree = true;

  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;

    stdlib = lib.readFile "${direnv}";
  };

  programs.htop.enable = true;
  programs.htop.settings.show_program_path = false;

  programs.fzf.enable = true;

  programs.nix-index = {
    enable = false;
    #   enableZshIntegration = true;
  };

  programs.tmux = {enable = true;};

  # programs.alacritty = {
  #   enable = true;
  #   settings = {
  #     font = {
  #       normal = {
  #         family = "Fira Code";
  #         style = "Retina";
  #       };
  #     };
  #   };
  # };

  programs.ssh = {
    enable = true;

    matchBlocks = lib.mkMerge [
      {
        "*" = {
          extraOptions = lib.mkIf stdenv.isDarwin {
            "IdentityAgent" = "/Users/tomas/.1password/agent.sock";
          };
        };
        wodan-wsl = {
          hostname = "192.168.1.46";
          user = "tomas";
          forwardAgent = true;
          extraOptions = {
            RequestTTY = "yes";
            HostKeyAlgorithms = "+ssh-rsa";
            # RemoteCommand = "tmux new -A -s \$\{\%n\}";
          };
        };
        silver-star = {
          hostname = "silver-star";
          user = "root";
          forwardAgent = true;
          extraOptions = {
            RequestTTY = "yes";
            # RemoteCommand = "tmux new -A -s \$\{\%n\}";
          };
        };
      }
      (import ./apps/ssh/match-blocks.nix {
        inherit lib;
      })
    ];
  };

  programs.atuin = {
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

  programs.git.enable = true;
  programs.git.userName = "Tomas Harkema";
  programs.git.userEmail = "tomas@harkema.io";

  programs.lazygit.enable = true;
  programs.lsd.enable = true;
  # programs.jq.enable = true;
  # programs.skim.enable = true;

  fonts.fontconfig.enable = true;

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      gcloud.disabled = true;
      nix_shell.disabled = false;

      hostname.disabled = false;

      sudo.disabled = false;
      shell.disabled = false;
      os.disabled = false;

      cmd_duration.min_time = 1000;
      command_timeout = 1000;

      directory = {
        fish_style_pwd_dir_length = 2;
      };
    };
  };

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    syntaxHighlighting.enable = true;
    # enableVteIntegration = true;
    enableSyntaxHighlighting = true;

    autocd = true;

    # history.extended = true;
    # history.expireDuplicatesFirst = true;
    # historySubstringSearch = {
    #   enable = true;
    #   # searchUpKey = "^[OA";
    #   # searchDownKey = "^[OB";
    # };

    initExtra = ''
      source "${iterm}";
    '';

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
        "completion"
        "autosuggestions"
        "prompt"
        "archive"
        "docker"
        "syntax-highlighting"
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
    };

    # antidote = {
    #   enable = true;
    #   plugins = [
    #     "tysonwolker/iterm-tab-colors"
    #     "MichaelAquilina/zsh-you-should-use"
    #   ];
    # };

    zplug = {
      enable = true;
      plugins = [
        {
          name = "tysonwolker/iterm-tab-colors";
        }
        {
          name = "mafredri/zsh-async";
        }
        {
          name = "MichaelAquilina/zsh-you-should-use";
        }
        {
          name = "unixorn/1password-op.plugin.zsh";
        }
      ];
    };

    # oh-my-zsh = {
    #   enable = true;
    #   plugins = [
    #     "1password"
    #     "autojump"
    #     "aws"
    #     "colorize"
    #     "docker"
    #     "encode64"
    #     "fzf"
    #     "git-extras"
    #     "git"
    #     "gitignore"
    #     "macos"
    #     "man"
    #     "mix"
    #     "nmap"
    #     "sudo"
    #     "systemd"
    #     "thefuck"
    #     "tig"
    #     "tmux"
    #     "vi-mode"
    #     "yarn"
    #     # "zsh-navigation-tools"
    #     "wd"
    #     # "iterm-tab-color"
    #   ];
    #   # theme = "powerlevel10k/powerlevel10k";
    # };
  };
}
