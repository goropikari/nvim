return {
  {
    'NeogitOrg/neogit',
    cmd = { 'Neogit' },
    -- version = '*',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'esmuellert/codediff.nvim',
      'folke/snacks.nvim',
    },
    opts = {
      integrations = {
        codediff = true,
      },
      diff_viewer = 'codediff',
    },
    keys = {
      {
        '<leader>G',
        '<cmd>Neogit<cr>',
        desc = 'Neogit',
      },
    },
  },
  {
    'lewis6991/gitsigns.nvim',
    version = '*',
    event = 'VeryLazy',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
      signs_staged_enable = false,
      current_line_blame = true,
    },
    keys = {
      { '<leader>g', desc = 'Git' },
      {
        '<leader>ga',
        function()
          require('gitsigns').stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
        end,
        desc = 'stage git hunk',
        mode = { 'v', 'n' },
      },
    },
  },
}
