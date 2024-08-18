-- Conky, a system monitor https://github.com/brndnmtthws/conky
--
-- This configuration file is Lua code. You can write code in here, and it will
-- execute when Conky loads. You can use it to generate your own advanced
-- configurations.
--
-- Try this (remove the `--`):
--
--   print("Loading Conky config")
--
-- For more on Lua, see:
-- https://www.lua.org/pil/contents.html
--
-- Conky Lua API: https://conky.cc/lua
-- Configuration settings: https://conky.cc/config_settings
conky.config = {
  alignment = "bottom_right",
  -- font = 'JetBrainsMono Nerd Font Mono:size=8',
  font = "B612Mono Nerd Font:size=12",
  background = false,
  border_width = 1,
  cpu_avg_samples = 2,
  color0 = "36E21D",
  default_color = "white",
  default_outline_color = "white",
  default_shade_color = "white",
  double_buffer = true,
  draw_borders = false,
  draw_graph_borders = true,
  draw_outline = false,
  draw_shades = false,
  extra_newline = false,
  gap_x = 60,
  gap_y = 60,
  minimum_height = 5,
  minimum_width = 5,
  net_avg_samples = 2,
  no_buffers = false,
  out_to_console = false,
  out_to_ncurses = false,
  out_to_stderr = false,
  out_to_wayland = false,
  out_to_x = false,
  own_window = true,
  own_window_class = "Conky",
  own_window_type = "normal",
  own_window_hints = "undecorated,sticky,below,skip_taskbar,skip_pager",
  show_graph_range = false,
  show_graph_scale = false,
  stippled_borders = 0,
  update_interval = 2.0,
  uppercase = true,
  use_spacer = "none",
  use_xft = true,
}

-- Variables: https://conky.cc/variables
conky.text = [[
${color lightgrey}$color $nodename ${color lightgrey}${addr}
$hr
${color grey} $sysname $nodename $kernel $machine $color
$hr
${color grey} UPT$color0 $uptime $color
${color grey} FRQ$color0 $freq_g $color
${color grey} RAM$color0 $mem/$memmax $color${membar 4} $color
${color grey} SWP$color0 $swap/$swapmax $color${swapbar 4} $color
${color grey} CPU$color0 $cpu% $color${cpubar 4} $color
${color grey} PRC$color0 $processes  ${color grey}RUN$color0 $running_processes  $color
$color$hr
${color grey} FSS $color0${fs_used /}/${fs_size /} $color${fs_bar 6 /} $color
${color grey} NET UP$color0 ${upspeed} ${color grey} DWN$color0 ${downspeed} $color
]]

-- $hr
-- ${color grey}Name              PID     CPU%   MEM%
-- ${color lightgrey} ${top name 1} ${top pid 1} ${top cpu 1} ${top mem 1}
-- ${color lightgrey} ${top name 2} ${top pid 2} ${top cpu 2} ${top mem 2}
-- ${color lightgrey} ${top name 3} ${top pid 3} ${top cpu 3} ${top mem 3}
-- ${color lightgrey} ${top name 4} ${top pid 4} ${top cpu 4} ${top mem 4}
