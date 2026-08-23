---@type Config
local options = {
   default_prog = {},
   launch_menu = {},
}

options.default_prog = { 'bash', '-l' }
options.launch_menu = {
   { label = 'Bash', args = { 'bash', '-l' } },
   { label = 'Fish', args = { 'fish', '-l' } },
   { label = 'Zsh', args = { 'zsh', '-l' } },
}

return options
