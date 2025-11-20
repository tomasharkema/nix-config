{
  pkgs,
  lib,
  ...
}: {
  oh-my-zsh = lib.mkIf false {
    enable = true;

    #extraConfig = ''
    #  ZSH_WEB_SEARCH_ENGINES=(nix-package "https://search.nixos.org/packages?query=" nix-option "https://search.nixos.org/options?query=")
    #'';
    plugins =
      [
        "1password"
        "autojump"
        "battery"
        "bgnotify"
        "colorize"
        "common-aliases"
        "copybuffer"
        "copyfile"
        "copypath"
        "cp"
        "dirhistory"
        "dirpersist"
        "dotnet"
        "emoji"
        "encode64"
        "extract"
        "fastfile"
        "fbterm"
        "fzf"
        "gh"
        "git-auto-fetch"
        "git-extras"
        "git-prompt"
        "git"
        "github"
        "gitignore"
        "golang"
        # "history-substring-search"
        # "history"
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
        "tailscale"
        "tig"
        "tldr"
        "tmux"
        "torrent"
        "transfer"
        "universalarchive"
        "urltools"
        "vscode"
        "wakeonlan"
        "wd"
        "web-search"
        "yarn"
        "uv"
        "z"
        "zoxide"
        "zsh-interactive-cd"
        "zsh-navigation-tools"
        # "direnv"
        # "docker"
        # "iterm-tab-color"
        # "you-should-use"
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
}
