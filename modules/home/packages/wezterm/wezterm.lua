-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This will hold the configuration.
local config = wezterm.config_builder()

config.color_scheme = "Catppuccin Mocha"

config.font = wezterm.font_with_fallback({ -- <built-in>, BuiltIn,
  {
    family = "JetBrainsMono Nerd Font Mono",
    weight = "Light",
  },
  -- /nix/store/664gs7n95z32zpg9mxngrs7r9p85sm5p-noto-fonts-emoji-2.038/share/fonts/noto/NotoColorEmoji.ttf, FontConfig
  -- Assumed to have Emoji Presentation
  -- Pixel sizes: [128]
  "Noto Color Emoji", -- <built-in>, BuiltIn
  "Symbols Nerd Font Mono",
})

-- config.font = wezterm.font 'JetBrains Mono'

-- config.window_background_opacity = 0.8
config.automatically_reload_config = true
-- config.macos_window_background_blur = 20

-- config.enable_scroll_bar = true

-- config.background = {
--   -- This is the deepest/back-most layer. It will be rendered first
--   {
--     source =
-- {Color="black" },
-- width = "100%",
-- },
-- }

config.keys = {
  {
    key = "l",
    mods = "ALT",
    action = wezterm.action.ShowLauncher,
  },

  -- {
  --   -- You can change the key binding to whatever you want:
  --   key = "g",
  --   mods = "LEADER",
  --   action = require("@wezPerProjectWorkspace@").action.ProjectWorkspaceSelect({
  --       base_dirs = {
  --           {
  --               path = wezterm.home_dir .. "/Developer",
  --               min_depth = 3,
  --               max_depth = 3,
  --           },
  --       },
  --       rooters = { ".git" },
  --       shorten_paths = true,
  --   }),
  -- },
}

-- config.enable_wayland = true

config.launch_menu = {
  {
    args = { "menu" },
  },
  {
    args = { "btop" },
  },
  { args = { "atop" } },
}

wezterm.plugin.require("@weztermStatus@").apply_to_config(config, { cells = { date = {
  format = " %H:%M:%S ",
} } })

return config
