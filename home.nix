{ config, pkgs, lib, ... }:
let inherit (pkgs) stdenv;
in {
  home.username = "tomas";
  home.homeDirectory = if stdenv.isLinux then "/home/tomas" else "/Users/tomas";
  home.stateVersion = "23.11";

  nixpkgs.config.allowUnfreePredicate = _: true;
  nixpkgs.config.allowUnfree = true;
  # home.stateVersion = "23.11";

  programs.direnv.enable = true;
  programs.direnv.nix-direnv.enable = true;

  programs.htop.enable = true;
  programs.htop.settings.show_program_path = false;

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
        # display = {
        #   threshold = 100;
        #   style = "bold red";
        # };
      };
      sudo.disabled = false;
      shell.disabled = false;
      # os.disabled = false;
    };
  };
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    ".zshrc".text = ''
      export EDITOR='subl -w'
      # autoload -Uz compinit
      # compinit

      # source ~/.zsh/plugins/iterm2_shell_integration
      # . ~/.zsh/plugins/iterm2_tmux_integration
    '';
  };
  programs.home-manager = { enable = true; };
  # programs.home-manager.enable = true;
  # programs.helix.enable = true;
  # programs.htop.enable = true;
  programs.lazygit.enable = true;
  programs.lsd.enable = true;
  programs.jq.enable = true;
  # programs.alacritty.enable = true;
  programs.skim.enable = true;

  programs.zsh = {
    enable = true;
    enableAutosuggestions = true;
    syntaxHighlighting.enable = true;
    enableVteIntegration = true;
    enableSyntaxHighlighting = true;
    # antidote = {
    #   enable = true;
    #   plugins = [
    #     "zsh-users/zsh-completions"
    #     "zsh-users/zsh-history-substring-search"
    #   ];
    # };
    autocd = true;
    history.extended = true;
    history.expireDuplicatesFirst = true;
    historySubstringSearch = {
      enable = true;
      searchUpKey = "^[OA";
      searchDownKey = "^[OB";
    };
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
        # "fzf-zsh-plugin"
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
        # "pijul"
      ];
      theme = "robbyrussell";
      # theme = "";
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
      # subl = "${pkgs.sublime4}";
      subl = "/Applications/Sublime\\ Text.app/Contents/SharedSupport/bin/subl";
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
    starship
    antidote
    thefuck
    coreutils
    curl
    wget
    git
    git-lfs

    tailscale
    fortune
    cachix
    niv

    go
    gotools
    gopls
    go-outline
    gocode
    gopkgs
    gocode-gomod
    godef
    golint
    colima
    python3
    # docker

    # swift

    neofetch
    tmux
    ansible-language-server
    # utm
    yq
    # bfg-repo-cleaner
    _1password
    tmux
    nixfmt
    nix-deploy
    colmena
    morph
    # vscode
    nnn
    mtr
    dnsutils
    ldns
    eza
    bottom
    multitail
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

# { config, pkgs, lib, ... }:

# {
#   # nix = {
#   #   # extra-experimental-features = "nix-command flakes";
#   #   # distributedBuilds = true;
#   #   # buildMachines = /etc/nix/machines;

#   #   extra-substituters =
#   #     [ "https://cachix.cachix.org" "https://tomasharkema.cachix.org" ];
#   #   extra-trusted-public-keys =
#   #     "tomasharkema.cachix.org-1:LOeGvH7jlA3vZmW9+gHyw0BDd1C8a0xrQSl9WHHTRuA=";
#   # };
#   # Home Manager needs a bit of information about you and the paths it should
#   # manage.
#   home.username = "tomas";
#   home.homeDirectory = "/Users/tomas";

#   # This value determines the Home Manager release that your configuration is
#   # compatible with. This helps avoid breakage when a new Home Manager release
#   # introduces backwards incompatible changes.
#   #
#   # You should not change this value, even if you update Home Manager. If you do
#   # want to update the value, then make sure to first check the Home Manager
#   # release notes.
#   home.stateVersion = "23.11"; # Please read the comment before changing.

#   programs.direnv.enable = true;
#   programs.direnv.nix-direnv.enable = true;

#   # Htop
#   # https://rycee.gitlab.io/home-manager/options.html#opt-programs.htop.enable
#   programs.htop.enable = true;
#   programs.htop.settings.show_program_path = false;

#   # The home.packages option allows you to install Nix packages into your
#   # environment.
#   home.packages = with pkgs; [
#     # # Adds the 'hello' command to your environment. It prints a friendly
#     # # "Hello, world!" when run.
#     # pkgs.hello

#     # # It is sometimes useful to fine-tune packages, for example, by applying
#     # # overrides. You can do that directly here, just don't forget the
#     # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
#     # # fonts?
#     # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

#     # # You can also create simple shell scripts directly inside your
#     # # configuration. For example, this adds a command 'my-hello' to your
#     # # environment:
#     # (pkgs.writeShellScriptBin "my-hello" ''
#     #   echo "Hello, ${config.home.username}!"
#     # '')
#     coreutils
#     curl
#     wget
#     git
#     git-lfs

#     tailscale
#     fortune
#     cachix
#     niv

#     go
#     gotools
#     gopls
#     go-outline
#     gocode
#     gopkgs
#     gocode-gomod
#     godef
#     golint
#     colima
#     docker

#     swift

#     neofetch
#     tmux
#     ansible-language-server
#     utm
#     yq
#     bfg-repo-cleaner
#     _1password
#     tmux
#     nixfmt
#     nix-deploy
#     colmena
#     morph
#     vscode
#     nnn
#     mtr
#     dnsutils
#     ldns
#     eza
#     vscode
#     # (vscode-with-extensions.override {
#     #   vscodeExtensions = with vscode-extensions;
#     #     [
#     #       bbenoist.nix
#     #       ms-python.python
#     #       ms-azuretools.vscode-docker
#     #       ms-vscode-remote.remote-ssh
#     #     ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [{
#     #       name = "remote-ssh-edit";
#     #       publisher = "ms-vscode-remote";
#     #       version = "0.47.2";
#     #       sha256 = "1hp6gjh4xp2m1xlm1jsdzxw9d8frkiidhph6nvl24d0h8z34w49g";
#     #     }];
#     # })
#   ];

#   # Home Manager is pretty good at managing dotfiles. The primary way to manage
#   # plain files is through 'home.file'.
#   home.file = {
#     # # Building this configuration will create a copy of 'dotfiles/screenrc' in
#     # # the Nix store. Activating the configuration will then make '~/.screenrc' a
#     # # symlink to the Nix store copy.
#     # ".screenrc".source = dotfiles/screenrc;

#     # # You can also set the file content immediately.
#     # ".gradle/gradle.properties".text = ''
#     #   org.gradle.console=verbose
#     #   org.gradle.daemon.idletimeout=3600000
#     # '';
#   };

#   # Home Manager can also manage your environment variables through
#   # 'home.sessionVariables'. If you don't want to manage your shell through Home
#   # Manager then you have to manually source 'hm-session-vars.sh' located at
#   # either
#   #
#   #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
#   #
#   # or
#   #
#   #  /etc/profiles/per-user/tomas/etc/profile.d/hm-session-vars.sh
#   #
#   home.sessionVariables = { EDITOR = "subl"; };

#   # Let Home Manager install and manage itself.
#   programs.home-manager.enable = true;

#   # home.username = "tomas";
#   # home.homeDirectory = "/home/tomas";
#   # home.stateVersion = "23.11";

#   # programs.direnv.enable = true;
#   # programs.direnv.nix-direnv.enable = true;

#   # programs.htop.enable = true;
#   # programs.htop.settings.show_program_path = false;
#   # programs.zsh.enable = true;
#   # home.packages = [
#   #   # pkgs is the set of all packages in the default home.nix implementation
#   #   pkgs.starship
#   # ];
#   programs.starship = {
#     enable = true;
#     enableZshIntegration = true;
#     settings = {
#       #   add_newline = false;
#       #   aws.disabled = false;
#       #   gcloud.disabled = true;
#       #   line_break.disabled = true;
#       # };
#       # shell = { disabled = false; };
#     };
#   };
#   home.file = {
#     # # Building this configuration will create a copy of 'dotfiles/screenrc' in
#     # # the Nix store. Activating the configuration will then make '~/.screenrc' a
#     # # symlink to the Nix store copy.
#     # ".screenrc".source = dotfiles/screenrc;

#     # # You can also set the file content immediately.
#     ".zshrc".text = ''
#       # Uncomment the following line to enable command auto-correction.
#       ENABLE_CORRECTION="true"
#       # source "/opt/homebrew/opt/spaceship/spaceship.zsh"
#       alias subl="/Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl"

#       export EDITOR='subl -w'
#       mkdir -p ~/.1password 2>/dev/null
#       ln -s ~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock ~/.1password/agent.sock 2>/dev/null
#     '';
#   };
#   # programs.home-manager = { enable = true; };
#   # programs.home-manager.enable = true;
#   programs.helix.enable = true;
#   # programs.htop.enable = true;
#   programs.lazygit.enable = true;
#   programs.lsd.enable = true;
#   programs.jq.enable = true;
#   programs.alacritty.enable = true;
#   programs.skim.enable = true;

#   programs.zsh = {
#     enable = true;
#     enableAutosuggestions = true;
#     syntaxHighlighting.enable = true;
#     enableVteIntegration = true;
#     historySubstringSearch.enable = true;
#     oh-my-zsh = {
#       enable = true;
#       plugins = [
#         "git"
#         "thefuck"
#         "autojump"
#         "gitignore"
#         "sudo"
#         "macos"
#         "zsh-autosuggestions"
#         "colorize"
#         "1password"
#         # "fzf-zsh-plugin"
#         "fzf"
#         "aws"
#         "docker"
#         "encode64"
#         "git"
#         "git-extras"
#         "man"
#         "nmap"
#         # "ssh-agent"
#         "sudo"
#         "systemd"
#         "tig"
#         "tmux"
#         "vi-mode"
#         "yarn"
#         "zsh-navigation-tools"
#         "mix"
#         "pijul"
#       ];
#       theme = "robbyrussell";

#     };
#     shellAliases = {
#       ll = "ls -l";
#       ls = "exa";
#       la = "exa -a";
#       grep = "grep --color=auto";
#       cp = "cp -i";
#       mv = "mv -i";
#       rm = "rm -i";
#       g = "git";
#       gs = "git status";
#     };
#   };
# }
