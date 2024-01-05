{
  pkgs,
  lib,
  ...
}: let
  tmux-super-fingers = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "tmux-super-fingers";
    version = "unstable-2023-01-06";
    src = pkgs.fetchFromGitHub {
      owner = "artemave";
      repo = "tmux_super_fingers";
      rev = "2c12044984124e74e21a5a87d00f844083e4bdf7";
      sha256 = "sha256-cPZCV8xk9QpU49/7H8iGhQYK6JwWjviL29eWabuqruc=";
    };
  };
  t-smart-manager = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "t-smart-tmux-session-manager";
    version = "unstable-2023-01-06";
    rtpFilePath = "t-smart-tmux-session-manager.tmux";
    src = pkgs.fetchFromGitHub {
      owner = "joshmedeski";
      repo = "t-smart-tmux-session-manager";
      rev = "a1e91b427047d0224d2c9c8148fb84b47f651866";
      sha256 = "sha256-HN0hJeB31MvkD12dbnF2SjefkAVgtUmhah598zAlhQs=";
    };
  };
in {
  config = {
    home.packages = with pkgs; [lsof brotab];

    programs.tmux = {
      enable = true;
      clock24 = true;
      shell = "${lib.getExe pkgs.zsh}";
      terminal = "tmux-256color";
      historyLimit = 200000;
      plugins = with pkgs; [
        {
          plugin = tmuxPlugins.catppuccin;
          extraConfig = ''
            set -g @catppuccin_flavour 'mocha'
          '';
          # set -g @catppuccin_window_tabs_enabled on
          # set -g @catppuccin_date_time "%H:%M"
        }

        # tmux-nvim
        tmuxPlugins.tmux-thumbs
        {
          plugin = t-smart-manager;
          extraConfig = ''
            set -g @t-fzf-prompt '  '
            set -g @t-bind "T"
          '';
        }
        {
          plugin = tmux-super-fingers;
          extraConfig = "set -g @super-fingers-key f";
        }
        tmuxPlugins.sensible
        {
          plugin = tmuxPlugins.resurrect;
          extraConfig = ''
            set -g @resurrect-strategy-vim 'session'
            # set -g @resurrect-strategy-nvim 'session'
            set -g @resurrect-capture-pane-contents 'on'
          '';
        }
        {
          plugin = tmuxPlugins.continuum;
          extraConfig = ''
            set -g @continuum-restore 'on'
            set -g @continuum-boot 'on'
            set -g @continuum-save-interval '10'
          '';
        }
        tmuxPlugins.better-mouse-mode
        tmuxPlugins.yank
        {
          plugin = tmuxPlugins.battery;
          extraConfig = ''
            set -g @catppuccin_status_modules_right "battery"
          '';
          # extraConfig = ''
          # set -g @catppuccin_status_modules_right '#{battery_status_bg} Batt: #{battery_icon} #{battery_percentage} #{battery_remain} | %a %h-%d %H:%M'
          # '';
        }
        tmuxPlugins.sidebar
        {
          plugin =
            tmuxPlugins.fpp;
          extraConfig = ''
            set -g @plugin 'tmux-plugins/tmux-fpp'
          '';
        }
        {
          plugin = tmuxPlugins.sysstat;
          # extraConfig = ''
          # set -g @catppuccin_status_modules_right '#{sysstat_cpu} | #{sysstat_mem} | #{sysstat_swap} | #{sysstat_loadavg}'
          # '';
        }
      ];
      # extraConfig = "";
    };
  };
}
