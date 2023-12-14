{ inputs, config, pkgs, lib, hostname, ... }@attrs:
let inherit (pkgs) stdenv;
in {

  nix.settings = {
    extra-experimental-features = "nix-command flakes";
    # distributedBuilds = true;
    trusted-users = [ "root" "tomas" ];
    extra-substituters = [
      # "ssh://nix-ssh@tower.ling-lizard.ts.net"
      "https://nix-cache.harke.ma/"
      "https://tomasharkema.cachix.org/"
      "https://cache.nixos.org/"
    ];
    extra-binary-caches = [
      "https://nix-cache.harke.ma/"
      "https://tomasharkema.cachix.org/"
      "https://cache.nixos.org/"
    ];
    extra-trusted-public-keys = [
      "tower.ling-lizard.ts.net:MBxJ2O32x6IcWJadxdP42YGVw2eW2tAbMp85Ws6QCno="
      "tomasharkema.cachix.org-1:LOeGvH7jlA3vZmW9+gHyw0BDd1C8a0xrQSl9WHHTRuA="
    ];
    access-tokens = [ "github.com=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" ];
  };

  imports = [
    ./apps/nvim
    ./apps/atuin
    ./apps/gnome/dconf.nix
    ./build-scripts.nix
    ./apps/tmux

  ]; # ++ [ (lib.optional (stdenv.isLinux) (./apps/flatpak.nix)) ];

  home.packages = (import ./packages/common.nix { inherit pkgs inputs; })
    ++ [ (pkgs.nerdfonts.override { fonts = [ "FiraCode" "DroidSansMono" ]; }) ]
    ++ (import ./apps/statix { inherit pkgs; });

  home.username = "tomas";
  home.homeDirectory = if stdenv.isLinux then
    lib.mkForce "/home/tomas"
  else
    lib.mkForce "/Users/tomas";

  home.stateVersion = "23.11";

  nixpkgs.config.allowUnfreePredicate = _: true;
  nixpkgs.config.allowUnfree = true;

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  programs.htop.enable = true;
  programs.htop.settings.show_program_path = false;

  programs.fzf.enable = true;
  programs.nix-index.enable = true;

  programs.tmux = { enable = true; };

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      gcloud.disabled = true;
      nix_shell.disabled = false;
      # battery = {
      #   full_symbol = "🔋 ";
      #   charging_symbol = "⚡️ ";
      #   discharging_symbol = "💀 ";

      # };
      sudo.disabled = false;
      shell.disabled = false;
      os.disabled = false;
    };
  };

  age.secrets.gh = {
    file = ./secrets/gh.age;
    path = if stdenv.isLinux then
      "/home/tomas/.config/gh/hosts.yml"
    else
      "/Users/tomas/.config/gh/hosts.yml";
  };
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".zshrc".text = ''
    #   export EDITOR='subl -w'
    #   # autoload -Uz compinit
    #   # compinit

    #   # source ~/.zsh/plugins/iterm2_shell_integration
    #   # . ~/.zsh/plugins/iterm2_tmux_integration
    # '';
  };

  programs.git.enable = true;
  programs.git.userName = "Tomas Harkema";
  programs.git.userEmail = "tomas@harkema.io";

  programs.home-manager = { enable = true; };
  programs.lazygit.enable = true;
  programs.lsd.enable = true;
  programs.jq.enable = true;
  programs.skim.enable = true;
  fonts.fontconfig.enable = true;
  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    syntaxHighlighting.enable = true;
    enableVteIntegration = true;
    enableSyntaxHighlighting = true;
    # initExtra = ''
    #   mkdir -p ~/.1password || true
    #   ln -s ~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock ~/.1password/agent.sock || true
    #   export SSH_AUTH_SOCK=~/.1password/agent.sock
    # '';
    antidote = {
      enable = true;
      plugins = [
        "zsh-users/zsh-completions"
        "zsh-users/zsh-history-substring-search"
      ];
    };
    autocd = true;
    history.extended = true;
    history.expireDuplicatesFirst = true;
    historySubstringSearch = {
      enable = true;
      # searchUpKey = "^[OA";
      # searchDownKey = "^[OB";
    };

    # autosuggestions.strategy = [ "history" "completion" "match_prev_cmd" ];

    oh-my-zsh = {
      enable = true;
      plugins = [
        # "atuin"
        "git"
        "thefuck"
        "autojump"
        "gitignore"
        "sudo"
        "macos"
        "colorize"
        "1password"
        # "fzf"
        "aws"
        "docker"
        "encode64"
        "git"
        "git-extras"
        "man"
        "nmap"
        "sudo"
        "systemd"
        "tig"
        # "tmux"
        "vi-mode"
        "yarn"
        "zsh-navigation-tools"
        "mix"
      ];
      theme = "robbyrussell";
    };
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
      # subl = "/Applications/Sublime\\ Text.app/Contents/SharedSupport/bin/subl";
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
      #   exec nix copy --to 'http://tower.ling-lizard.ts.net:6666/' $OUT_PATHS'';

      # upload-after-build = ''
      #   jq -r '.[].outputs | to_entries[].value' | nix copy --to 'https://nix-cache.harke.ma' --stdin
      # '';
    };
    # plugins = [{
    #   name = "iterm2_shell_integration";
    #   src = pkgs.fetchurl {
    #     url = "https://iterm2.com/shell_integration/zsh";
    #     sha256 = "1xk6kx5kdn5wbqgx2f63vnafhkynlxnlshxrapkwkd9zf2531bqa";
    #     # date = 2022-12-28T10:15:23-0800;
    #   };
    # }
    # {
    #   name = "iterm2_tmux_integration";
    #   src = pkgs.fetchurl {
    #     url =
    #       "https://gist.githubusercontent.com/antifuchs/c8eca4bcb9d09a7bbbcd/raw/3ebfecdad7eece7c537a3cd4fa0510f25d02611b/iterm2_zsh_init.zsh";
    #     sha256 = "1v1b6yz0lihxbbg26nvz85c1hngapiv7zmk4mdl5jp0fsj6c9s8c";
    #     # date = 2022-12-28T10:15:27-0800;
    #   };
    # }
    # ];
  };
}
