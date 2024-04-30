-- Pull in the wezterm API
local wezterm = require 'wezterm'

-- This will hold the configuration.
local config = wezterm.config_builder()

config.color_scheme = "Catppuccin Mocha"

config.font = wezterm.font_with_fallback({ -- <built-in>, BuiltIn
"JetBrains Mono",

-- /nix/store/664gs7n95z32zpg9mxngrs7r9p85sm5p-noto-fonts-emoji-2.038/share/fonts/noto/NotoColorEmoji.ttf, FontConfig
-- Assumed to have Emoji Presentation
-- Pixel sizes: [128]
"Noto Color Emoji", -- <built-in>, BuiltIn
"Symbols Nerd Font Mono"})
-- config.window_background_opacity = 0.8
config.automatically_reload_config = true
-- config.macos_window_background_blur = 20

config.keys = {{
    key = 'l',
    mods = 'ALT',
    action = wezterm.action.ShowLauncher
}}

config.launch_menu = {{
    args = {'menu'}
}, {
    args = {'top'}
}, {
    -- Optional label to show in the launcher. If omitted, a label
    -- is derived from the `args`
    label = 'Bash',
    -- The argument array to spawn.  If omitted the default program
    -- will be used as described in the documentation above
    args = {'bash', '-l'}

    -- You can specify an alternative current working directory;
    -- if you don't specify one then a default based on the OSC 7
    -- escape sequence will be used (see the Shell Integration
    -- docs), falling back to the home directory.
    -- cwd = "/some/path"

    -- You can override environment variables just for this command
    -- by setting this here.  It has the same semantics as the main
    -- set_environment_variables configuration option described above
    -- set_environment_variables = { FOO = "bar" },
}}

return config
