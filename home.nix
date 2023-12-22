{ inputs
, config
, pkgs
, lib
, hostname
, ...
} @ attrs:
let
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

in
{
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
    ./apps/nvim
    ./apps/hishtory
  ]; # ++ [ (lib.optional (stdenv.isLinux) (./apps/flatpak.nix)) ];
  # self.home-manager.backupFileExtension = "bak";
  home.packages =
    (import ./packages/common.nix attrs)
    ++ [ (pkgs.nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; }) ]
    ++ (import ./apps/statix { inherit pkgs; })
    ++ [
      pkgs.nixd
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

  nixpkgs.config.allowUnfreePredicate = _: true;
  nixpkgs.config.allowUnfree = true;

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  services.kbfs.enable = lib.mkIf stdenv.isLinux true;

  programs.htop.enable = true;
  programs.htop.settings.show_program_path = false;

  programs.fzf.enable = true;
  programs.nix-index =
    {
      enable = true;
      enableZshIntegration = true;
    };

  programs.tmux = { enable = true; };

  programs.alacritty = {
    enable = true;
    settings = {
      font = {
        normal = {
          family = "Fira Code";
          style = "Retina";
        };
      };
    };
  };

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
    };
  };

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
      (import ./users/match-blocks.nix {
        inherit lib;
      })
    ];
  };

  programs.git.enable = true;
  programs.git.userName = "Tomas Harkema";
  programs.git.userEmail = "tomas@harkema.io";

  programs.lazygit.enable = true;
  programs.lsd.enable = true;
  programs.jq.enable = true;
  # programs.skim.enable = true;

  fonts.fontconfig.enable = true;

  programs.zsh = {
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

    # zplug = {
    #   enable = true;
    #   plugins = [
    #     {
    #       name = "zsh-users/zsh-syntax-highlighting";
    #       tags = [ defer:2 ];
    #     }
    #     {
    #       name = "zsh-users/zsh-autosuggestions";
    #       tags = [ defer:2 ];
    #     }
    #     {
    #       name = "zsh-users/zsh-completions";
    #       tags = [ defer:2 ];
    #     }
    #     {
    #       name = "tysonwolker/iterm-tab-colors";
    #     }
    #     {
    #       name = "mafredri/zsh-async";
    #     }
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
      ];
      # theme = "powerlevel10k/powerlevel10k";
    };
  };
}
