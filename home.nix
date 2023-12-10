{ inputs, config, pkgs, lib, hostname, ... }:
let inherit (pkgs) stdenv;
in {

  # nix.settings = {
  #   extra-experimental-features = "nix-command flakes";
  #   # distributedBuilds = true;
  #   trusted-users = [ "root" "tomas" ];
  #   extra-substituters = [ "https://tomasharkema.cachix.org" ];
  #   extra-trusted-public-keys =
  #     "tomasharkema.cachix.org-1:LOeGvH7jlA3vZmW9+gHyw0BDd1C8a0xrQSl9WHHTRuA=";
  # };

  imports =
    [ ./apps/nvim ./apps/atuin ./apps/gnome/dconf.nix ./build-scripts.nix ];

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

  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      gcloud.disabled = true;
      nix_shell.disabled = false;
      battery = {
        full_symbol = "🔋 ";
        charging_symbol = "⚡️ ";
        discharging_symbol = "💀 ";

      };
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
  programs.git.userName = "tomasharkema";
  programs.git.userEmail = "tomas@harkema.io";
  # programs.git.extraConfig = ''
  #   url.git@github.com:.insteadof=gh:
  #   url.git@github.com:.pushinsteadof=github:
  #   url.git@github.com:.pushinsteadof=git://github.com/
  #   url.git://github.com/.insteadof=github:
  #   url.git@gist.github.com:.insteadof=gst:
  #   url.git@gist.github.com:.pushinsteadof=gist:
  #   url.git@gist.github.com:.pushinsteadof=git://gist.github.com/
  #   url.git://gist.github.com/.insteadof=gist:
  #   init.defaultbranch=main
  #   user.name=Tomas Harkema
  #   user.email=tomas@harkema.io
  #   user.signingkey=ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDRzOjHZdqy0NfDPi9+9onjJKYQA23+0v+a0nnQ0VgvMCEPyHzM3UQwrq6RNNXt/8OQ1U89cFz726mL/nNljeSvfFodmSukk5h7D+5pQwTLTVQprmjumHJU8S6JgW8d2RYbvUlPxOed4kPkBD414qQoi+nQTynDPP
  #   KnIzFWuLEgDmSsS0KMb+l6Y0AdC9X+i3lMT1cK8EqsqIDjGvnFaTyXisr/yjdx3nR/1X9qD1PXQmbnw0dRa7EJZ5kQ9J8Zllju3qe98LibD8Kgsu0QeXYf3Hwm18JWq5uJdKobeyditg2deIfKwXk8fgk8S7lfZwaR+WLDhh3cU+Fo43BRgl9FJx04GjXjqMs9OOO5xVsLF+ch+EdMPwO2
  #   ag7lYxXfBQNwkNDOk6PSoaHwSXrnOMQIgo2zUh4W689pL8AbMGnvLvQSo106EtKB1WTJF1ZjvSBpYNeN9TUxZ3RrnbDsJDT/gQ6NeUTFa5/wliiHjWQ6N4p8m87kIlGQRzjEg70YfJjPQ/6KRH6j6w/MoKCNC04tbDiQMWFbxha+1rIedjOGUOz0uKgbKbuphvBeTTtWkDf2N5mr1/kVI/
  #   4MP6Hi2+X4Px/s0G42pUFyHom1WuUn/igFWTIo5t5G9pSm4ltLWEeacEdRepkjoCgNkABaOA10B0QZIFab0HdURMdnEYiYIQ==
  #   gpg.format=ssh
  #   gpg.program=/usr/local/bin/gpg
  # '';

  programs.home-manager = { enable = true; };
  programs.lazygit.enable = true;
  programs.lsd.enable = true;
  programs.jq.enable = true;
  programs.skim.enable = true;

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
        "git"
        "thefuck"
        "autojump"
        "gitignore"
        "sudo"
        "macos"
        "colorize"
        "1password"
        "fzf"
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
        "tmux"
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
      subl = "/Applications/Sublime\\ Text.app/Contents/SharedSupport/bin/subl";
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
    };
    plugins = [{
      name = "iterm2_shell_integration";
      src = pkgs.fetchurl {
        url = "https://iterm2.com/shell_integration/zsh";
        sha256 = "1xk6kx5kdn5wbqgx2f63vnafhkynlxnlshxrapkwkd9zf2531bqa";
        # date = 2022-12-28T10:15:23-0800;
      };
    }
    # {
    #   name = "iterm2_tmux_integration";
    #   src = pkgs.fetchurl {
    #     url =
    #       "https://gist.githubusercontent.com/antifuchs/c8eca4bcb9d09a7bbbcd/raw/3ebfecdad7eece7c537a3cd4fa0510f25d02611b/iterm2_zsh_init.zsh";
    #     sha256 = "1v1b6yz0lihxbbg26nvz85c1hngapiv7zmk4mdl5jp0fsj6c9s8c";
    #     # date = 2022-12-28T10:15:27-0800;
    #   };
    # }
      ];
  };

  home.packages = with pkgs; [
    home-manager
    starship
    antidote
    thefuck
    coreutils
    curl
    wget
    git
    git-lfs
    tailscale
    ssh-to-age
    fortune
    cachix
    niv
    # sublime4
    colima
    python3
    neofetch
    tmux
    ansible-language-server
    # utm
    yq
    bfg-repo-cleaner
    _1password
    tmux
    nixfmt
    nix-deploy
    colmena
    morph
    nnn
    mtr
    dnsutils
    ldns
    eza
    bottom
    multitail
    netdiscover
    obsidian
    tree
    inputs.agenix.packages.${system}.default
    # atuin
    thefuck
    nixd
    nil
    rnix-lsp
    ## Nix tools
    nix-index
    nix-prefetch-scripts
    patchelf
    # moonlight
    # (vscode-with-extensions.override {
    #   vscodeExtensions = with vscode-extensions;
    #     [
    #       bbenoist.nix
    #       ms-python.python
    #       ms-azuretools.vscode-docker
    #       ms-vscode-remote.remote-ssh
    #     ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [{
    #       name = "remote-ssh-edit";
    #       publisher = "ms-vscode-remote";
    #       version = "0.47.2";
    #       sha256 = "1hp6gjh4xp2m1xlm1jsdzxw9d8frkiidhph6nvl24d0h8z34w49g";
    #     }];
    # })
  ];
}
