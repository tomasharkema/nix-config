{
  inputs,
  config,
  pkgs,
  system,
  lib,
  osConfig,
  ...
}:
with lib; let
  coc = import ./coc.nix;
in {
  # imports = [ inputs.nixvim.homeManagerModules.nixvim ];

  config = {
    home.packages = with pkgs; [
      figlet
      nodejs
      ripgrep
    ];

    programs.neovim = {
      viAlias = true;
      vimAlias = true;
      defaultEditor = true;
    };

    xdg.configFile = {
      "nvim/coc-settings.json" = {
        source = builtins.toFile "coc-settings.json" (
          builtins.toJSON (coc {
            homeDir = config.xdg.configHome;
          })
        );
      };
    };

    programs.nixvim = {
      enable = true;
      # enableMan = false;

      colorschemes.catppuccin.enable = true;

      # treesitter = {
      # enable = true;
      # package = pkgs.vimPlugins.nvim-treesitter.withAllGrammars;
      # };
      plugins.dashboard = {
        enable = true;
      };
      plugins.neo-tree = {
        enable = true;
      };
      plugins.project-nvim = {
        enable = true;
      };
      plugins.telescope = {
        enable = true;
      };
      plugins.fugitive = {
        enable = true;
      };
      plugins.lualine = {
        enable = true;
        sections = {
          lualine_x = [
            "diagnostics"
            "encoding"
            "filetype"
          ];
        };
      };
      # startify = {
      #   enable = true;
      #   customHeader = ''
      #     startify#pad(split(system('figlet -f larry3d neovim'), '
      #     '))'';
      # };
      # indent-blankline = {
      #   enable = true;
      #   filetypeExclude = ["startify"];
      # };
      plugins.barbar = {
        enable = true;
      };
      plugins.gitgutter = {
        enable = true;
      };
      plugins.surround = {
        enable = true;
      };
      plugins.nvim-colorizer = {
        enable = true;
      };
      plugins.nix-develop.enable = true;
      plugins.notify.enable = true;
      plugins.zellij.enable = true;
      plugins.nix = {
        enable = true;
      };
      plugins.fzf-lua = {enable = true;};
      plugins.auto-save = {
        enable = true;
        enableAutoSave = true;
      };
      plugins.git-worktree = {
        enable = true;
      };
      plugins.direnv = {enable = true;};
      plugins.multicursors.enable = true;
      plugins.toggleterm = {
        enable = true;
      };
      plugins.floaterm = {
        enable = true;
      };
      plugins.zig = {
        enable = true;
      };
      # cmp-zsh.enable = true;
      plugins.conform-nvim = {
        enable = true;
        # formatOnSave = true;
        formattersByFt = {
          lua = ["stylua"];
          nix = ["alejandra"];
        };
      };

      extraPlugins = with pkgs.vimPlugins; [
        # ansible-vim
        vim-nix
        coc-nvim
        # suda-vim
      ];

      options = {
        number = true;
        syntax = "enable";
        fileencodings = "utf-8,sjis,euc-jp,latin";
        encoding = "utf-8";
        title = true;
        autoindent = true;

        background = "dark";
        backup = false;
        hlsearch = true;
        showcmd = true;
        cmdheight = 1;
        laststatus = 2;
        scrolloff = 10;
        expandtab = true;
        shell = "zsh";
        backupskip = "/tmp/*,/private/tmp/*";
        inccommand = "split";
        ruler = false;
        showmatch = false;
        lazyredraw = true;
        ignorecase = true;
        smarttab = true;
        shiftwidth = 2;
        tabstop = 2;
        ai = true;
        ci = true;
        wrap = true;
        backspace = "start,eol,indent";
        path = "vim.opts.path + **";
        wildignore = "vim.opts.wildignore + */node_modules/*";
        cursorline = true;
        exrc = true;
        mouse = "a";
        suffixesadd = ".js,.es,.jsx,.json,.css,.less,.sass,.styl,.php,.py,.md,.nix";
      };

      autoCmd = [
        {
          event = ["InsertLeave"];
          pattern = ["*"];
          command = "set nopaste";
        }
        {
          event = ["WinEnter"];
          pattern = ["*"];
          command = "set cul";
        }
        {
          event = ["WinLeave"];
          pattern = ["*"];
          command = "set nocul";
        }
      ];
      highlight = {
        BufferCurrent = {
          fg = "#eceff4";
          bg = "#434c5e";
          bold = true;
        };
        BufferCurrentMod = {
          fg = "#ebcb8b";
          bg = "#434c5e";
          bold = true;
        };
        BufferCurrentSign = {
          fg = "#4c566a";
          bg = "#4c566a";
        };
        BufferCurrentTarget = {
          bg = "#434c5e";
        };
        BufferInactive = {
          fg = "#4c566a";
          bg = "none";
        };
        BufferInactiveSign = {
          fg = "#4c566a";
          bg = "none";
        };
        BufferInactiveMod = {
          fg = "#ebcb8b";
          bg = "none";
        };
        BufferTabpageFill = {
          fg = "#4c566a";
          bg = "none";
        };
      };
      globals = {
        # coc_filetype_map = { "yaml.ansible" = "ansible"; };
        # coc_global_extensions = [ "coc-explorer" "@yaegassy/coc-ansible" ];
        # suda_smart_edit = 1;
        # "suda#nopass" = 1;
      };
      extraConfigLua = ''
        vim.api.nvim_set_hl(0, "MatchParen", { bg="#4c566a", fg="#88c0d0" })
      '';
      extraConfigVim = ''
        nnoremap <c-s> :w<cr>

        inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"
        set undofile
        set clipboard+=unnamedplus
        function CheckForExplorer()
        if CocAction('runCommand', 'explorer.getNodeInfo', 'closest') isnot# v:null
          CocCommand explorer --toggle
            endif
            endfunction
      '';

      keymaps = [
        {
          key = ";";
          action = ":";
        }
      ];

      # maps = {
      #   normal."sf" = {
      #     silent = true;
      #     action = "<cmd>CocCommand explorer<cr>";
      #   };
      #   normal.";r" = {
      #     silent = true;
      #     action = ":call CheckForExplorer()<CR> <cmd>lua require('telescope.builtin').live_grep()<cr>";
      #   };
      #   normal.";f" = {
      #     silent = true;
      #     action = ":call CheckForExplorer()<CR> <cmd>lua require('telescope.builtin').find_files()<cr>";
      #   };
      #   normal.";b" = {
      #     silent = true;
      #     action = ":call CheckForExplorer()<CR> <cmd>lua require('telescope.builtin').file_browser()<cr>";
      #   };
      #   normal."\\" = {
      #     silent = true;
      #     action = ":call CheckForExplorer()<CR> <cmd>Telescope buffers<cr>";
      #   };
      #   normal.";;" = {
      #     silent = true;
      #     action = ":call CheckForExplorer()<CR> <cmd>Telescope help_tags<cr>";
      #   };
      # };
    };
  };
}
