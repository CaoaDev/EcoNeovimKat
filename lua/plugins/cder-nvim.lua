-- The title of the prompt.
prompt_title = 'cder',

-- The command used to generate a list of directories.
-- Defaults to fd on the home directory.
-- Example for showing hidden directories:
--   dir_command = { 'fd', '--hidden', '--type=d', '.', os.getenv('HOME') },
dir_command = { 'fd', '--type=d', '.', os.getenv('HOME') },

-- The binary used to execute previewer_command | pager_command.
-- This is needed because termopen in Neovim does not support piping
-- multiple commands, so we get around this by just using bash -c.
command_executer = { 'bash', '-c' },

-- The command used to preview directories. Defaults to ls.
-- Example:
--   previewer_command = 'exa -a --icons'
previewer_command = 'ls -a',

-- The command used to page directory previews. Defaults to bat.
-- Receives the output of the previewer_command as input.
-- Example without bat:
--   pager_command = 'less -RS'
pager_command = 'bat --plain --paging=always --pager="less -RS"',

-- Function to create an entry in the picker given
-- a line outputted from the dir_command.
--   value is used as the directory in the :cd command
--   display is what is actually displayed, so this can
--     be a function that trims a path prefix for example.
entry_maker = function(line)
  return {
    value = line,
    display = function(entry)
      return ' ' .. line:gsub(os.getenv('HOME') .. '/', ''), { { { 1, 3 }, 'Directory' } }
    end,
    ordinal = line,
  }
end,
