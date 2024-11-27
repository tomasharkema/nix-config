{
  pkgs,
  lib,
  ...
}: {
  config = {
    home.packages = with pkgs; [lsof brotab];

    programs.zellij = {
      enable = true;

      # enableZshIntegration = true;

      settings = {
        theme = "catppuccin-mocha";
        load_plugins = {
          # "${pkgs.zjstatus}/bin/zjframes.wasm" = {
          #   hide_frame_for_single_pane = "true";
          #   hide_frame_except_for_search = "true";
          #   hide_frame_except_for_fullscreen = "true";
          # };
          "https://github.com/cristiand391/zj-status-bar/releases/download/0.3.0/zj-status-bar.wasm" = {};
        };
      };
    };

    home.file = {
      # ".config/zellij/config.kdl".text = ''
      #   theme "catppuccin-mocha"

      #   load_plugins {
      #     "${pkgs.zjstatus}/bin/zjframes.wasm" {
      #       hide_frame_for_single_pane       "true"
      #       hide_frame_except_for_search     "true"
      #       hide_frame_except_for_fullscreen "true"
      #     }
      #   }
      # '';
      # file:${pkgs.custom.zj-status-bar}/bin/zj-status-bar.wasm
      ".config/zellij/layouts/default.kdl".text = ''
        layout {
          pane size=1 {
            plugin location="https://github.com/cristiand391/zj-status-bar/releases/download/0.3.0/zj-status-bar.wasm"
          }
          pane
        }
      '';

      #${pkgs.zjstatus}/bin/zjstatus.wasm
      # ".config/zellij/layouts/default.kdl".text = ''
      #   layout {
      #     default_tab_template {
      #       children
      #       pane size=1 borderless=true {
      #         plugin location="file:${pkgs.zjstatus}/bin/zjstatus.wasm" {
      #           format_left   "{mode} #[fg=#89B4FA,bold]{session}"
      #           format_center "{tabs}"
      #           format_right  "{command_git_branch} {datetime}"
      #           format_space  ""

      #           border_enabled  "false"
      #           border_char     "─"
      #           border_format   "#[fg=#6C7086]{char}"
      #           border_position "top"

      #           hide_frame_for_single_pane "true"

      #           mode_normal  "#[bg=blue] "
      #           mode_tmux    "#[bg=#ffc387] "

      #           tab_normal   "#[fg=#6C7086] {name} "
      #           tab_active   "#[fg=#9399B2,bold,italic] {name} "

      #           command_git_branch_command     "git rev-parse --abbrev-ref HEAD"
      #           command_git_branch_format      "#[fg=blue] {stdout} "
      #           command_git_branch_interval    "10"
      #           command_git_branch_rendermode  "static"

      #           datetime        "#[fg=#6C7086,bold] {format} "
      #           datetime_format "%A, %d %b %Y %H:%M"
      #           datetime_timezone "Europe/Amsterdam"
      #         }
      #       }
      #     }
      #   }
      # '';
    };
  };
}
