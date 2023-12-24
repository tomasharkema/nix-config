{pkgs, ...}: {
  programs.starship = {
    enable = true;
    # settings = {
    #   add_newline = false;
    #   aws.disabled = false;
    #   gcloud.disabled = true;
    #   line_break.disabled = true;
    # };
  };

  users.defaultUserShell = pkgs.zsh;
  programs.fzf.fuzzyCompletion = true;
  programs.zsh = {
    enable = true;
    # autosuggestions.enable = true;
    # enableCompletion = true;
    # autosuggestions.async = true;
    ohMyZsh = {
      enable = true;
      plugins = [
        "git"
        "thefuck"
        "autojump"
        "gitignore"
        "sudo"
        "macos"
        "zsh-autosuggestions"
        "colorize"
        "1password"
        "fzf-zsh-plugin"
        "fzf"
        "aws"
        "docker"
        "encode64"
        "git"
        "git-extras"
        "man"
        "nmap"
        "ssh-agent"
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
    };
  };
}
