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
      rev = "518044ef78efa1cf3c64f2e693fef569ae570ddd";
      sha256 = "sha256-iKfx9Ytk2vSuINvQTB6Kww8Vv7i51cFEnEBHLje+IJw=";
    };
  };
  #   sesh = pkgs.tmuxPlugins.mkTmuxPlugin {
  #   pluginName = "t-smart-tmux-session-manager";
  #   version = "unstable-2023-01-06";
  #   rtpFilePath = "t-smart-tmux-session-manager.tmux";
  #   src = pkgs.fetchFromGitHub {
  #     owner = "joshmedeski";
  #     repo = "sesh";
  #     rev = "a2d2af470f7df91abc50619de893748b6f0cca82";
  #     hash = "sha256-sCLjjoseA3v3P5cH26cYQ1dzUtXV0Se8TzgaXT4lYpQ=";
  #   };
  # };
  t-smart-manager = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "t-smart-tmux-session-manager";
    version = "unstable-2023-01-06";
    rtpFilePath = "t-smart-tmux-session-manager.tmux";
    src = pkgs.fetchFromGitHub {
      owner = "joshmedeski";
      repo = "t-smart-tmux-session-manager";
      rev = "3726950525ac9966412ea3f2093bf2ffe06aa023";
      sha256 = "sha256-AMeYo3HVtRP1w8gQpok+/9fvNCXiMEzZ9ct+gUoL2V4=";
    };
  };
in
  with lib; {
    config = mkIf true {
      home.packages = with pkgs; [lsof brotab tmux zellij];

      programs.zellij = {
        enable = true;
        # enableZshIntegration = true;
        settings = {
          theme = "catppuccin-mocha";
        };
      };

      home.file = {
        ".config/zellij/layouts/_default.kdl".text = ''
          layout {
              default_tab_template {
                  children
                  pane size=1 borderless=false {
                      plugin location="https://github.com/dj95/zjstatus/releases/latest/download/zjstatus.wasm" {
                          format_left   "{mode} #[fg=#89B4FA,bold]{session}"
                          format_center "{tabs}"
                          format_right  "{command_git_branch} {datetime}"
                          format_space  ""

                          border_enabled  "false"
                          border_char     "─"
                          border_format   "#[fg=#6C7086]{cha`r}"
                          border_position "top"

                          hide_frame_for_single_pane "true"

                          mode_normal  "#[bg=blue] "
                          mode_tmux    "#[bg=#ffc387] "

                          tab_normal   "#[fg=#6C7086] {name} "
                          tab_active   "#[fg=#9399B2,bold,italic] {name} "

                          command_git_branch_command     "git rev-parse --abbrev-ref HEAD"
                          command_git_branch_format      "#[fg=blue] {stdout} "
                          command_git_branch_interval    "10"
                          command_git_branch_rendermode  "static"

                          datetime        "#[fg=#6C7086,bold] {format} "
                          datetime_format "%A, %d %b %Y %H:%M"
                          datetime_timezone "Europe/Berlin"
                      }
                  }
              }
          }

        '';
      };

      programs.tmux = mkIf false {
        enable = true;
        clock24 = true;
        # shell = "${lib.getExe pkgs.zsh}";
        # terminal = "tmux-256color";
        # historyLimit = 200000;
        mouse = true;

        tmuxinator.enable = true;
        tmuxp.enable = true;

        plugins = with pkgs; [
          tmuxPlugins.better-mouse-mode
          {
            plugin = tmuxPlugins.catppuccin;
            extraConfig = ''
              set -g @catppuccin_flavour 'mocha'

              set -g @catppuccin_window_left_separator ""
              set -g @catppuccin_window_right_separator " "
              set -g @catppuccin_window_middle_separator " █"
              set -g @catppuccin_window_number_position "right"

              set -g @catppuccin_window_default_fill "number"
              set -g @catppuccin_window_default_text "#W"

              set -g @catppuccin_window_current_fill "number"
              set -g @catppuccin_window_current_text "#W"

              set -g @catppuccin_status_modules_right "application session user host date_time"

              set -g @catppuccin_status_left_separator  " "
              set -g @catppuccin_status_right_separator ""
              set -g @catppuccin_status_right_separator_inverse "no"
              set -g @catppuccin_status_fill "icon"
              set -g @catppuccin_status_connect_separator "no"

              set -g @catppuccin_directory_text "#{pane_current_path}"
              set -g @catppuccin_window_tabs_enabled on
              set -g @catppuccin_date_time "%H:%M"
            '';
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
              set -g @resurrect-strategy-nvim 'session'
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
          tmuxPlugins.yank
          # tmuxPlugins.battery
          # {
          #   plugin = tmuxPlugins.battery;
          #   extraConfig = ''
          #     set -g @catppuccin_status_modules_right "battery"
          #   '';
          #   # extraConfig = ''
          #   # set -g @catppuccin_status_modules_right '#{battery_status_bg} Batt: #{battery_icon} #{battery_percentage} #{battery_remain} | %a %h-%d %H:%M'
          #   # '';
          # }
          tmuxPlugins.sidebar
          tmuxPlugins.fpp
          # {
          #   plugin =
          #     tmuxPlugins.fpp;
          #   extraConfig = ''
          #     set -g @plugin 'tmux-plugins/tmux-fpp'
          #   '';
          # }
          # tmuxPlugins.sysstat
          # {
          #   plugin = tmuxPlugins.sysstat;
          #   # extraConfig = ''
          #   # set -g @catppuccin_status_modules_right '#{sysstat_cpu} | #{sysstat_mem} | #{sysstat_swap} | #{sysstat_loadavg}'
          #   # '';
          # }
        ];
        # extraConfig = ''
        #   set -g status-right-length 80
        #   set -g status-right '#(exec tmux ls| cut -d " " -f 1-3 |tr "\\n" "," )'
        # '';
      };
    };
  }
