return {
  {
    'goropikari/terminals.nvim',
    lazy = false,
    opts = {
      commands = {
        'TerminalPicker',
        'TerminalSetPosition',
      },
      keymaps = {
        next = { lhs = '<A-n>', modes = { 'n', 't' } },
        move_right = { lhs = '<C-A-n>', modes = { 'n', 't' } },
      },
      terminal_position = 'bottom',
      terminal_height = 0.4,
    },
    keys = {
      {
        '<c-t>',
        function()
          require('terminals.terminal').toggle()
        end,
      },
      {
        '<leader>ss',
        function()
          require('terminals.terminal').send_current_line()
        end,
        mode = 'n',
        desc = 'send line to terminal',
      },
      {
        '<leader>ss',
        function()
          vim.cmd([[ execute "normal! \<ESC>" ]])
          vim.schedule(function()
            require('terminals.terminal').send_visual_selection()
          end)
        end,
        mode = 'v',
        desc = 'Send selection to terminal',
      },
    },
  },
  {
    'direnv/direnv.vim',
  },
  {
    'goropikari/devcontainer-template.nvim',
    dependencies = {
      'folke/snacks.nvim',
    },
    opts = {
      picker = 'snacks',
    },
  },
}
