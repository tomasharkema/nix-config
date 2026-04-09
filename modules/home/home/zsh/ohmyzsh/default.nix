{
  pkgs,
  lib,
  ...
}: {
  config = {
    programs.zsh.oh-my-zsh = {
      enable = true;

      #extraConfig = ''
      #  ZSH_WEB_SEARCH_ENGINES=(nix-package "https://search.nixos.org/packages?query=" nix-option "https://search.nixos.org/options?query=")
      #'';
      plugins =
        [
          # keep-sorted start
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
          # "zsh-navigation-tools"
          "direnv"
          "dirhistory"
          "dirpersist"
          "docker"
          "dotnet"
          "emoji"
          "encode64"
          "extract"
          "fastfile"
          "fbterm"
          "fzf"
          "gh"
          "git"
          "git-auto-fetch"
          "git-extras"
          "git-prompt"
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
          "sublime"
          "sublime-merge"
          "sudo"
          "swiftpm"
          "systemd"
          "tailscale"
          "tig"
          "tldr"
          "tmux"
          "torrent"
          "transfer"
          "universalarchive"
          "urltools"
          "uv"
          "vscode"
          "wakeonlan"
          "web-search"
          "yarn"
          "z"
          "zoxide"
          "zsh-interactive-cd"
          # "iterm-tab-color"
          # "you-should-use"
          # keep-sorted end
        ]
        ++ (lib.optionals pkgs.stdenv.isDarwin [
          # keep-sorted start
          "brew"
          "dash"
          "macos"
          "pod"
          "xcode"
          # keep-sorted end
        ])
        ++ (lib.optionals pkgs.stdenv.isLinux [
          # keep-sorted start
          "firewalld"
          "systemd"
          # keep-sorted end
        ]);
      #   # theme = "powerlevel10k/powerlevel10k";
    };
  };
}
