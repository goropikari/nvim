return {
  {
    'nvim-treesitter/nvim-treesitter',
    branch = 'main',
    lazy = false,
    build = ':TSUpdate',
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    version = '*',
    opts = {
      on_attach = function()
        return true
      end,
    },
  },
  {
    'Wansmer/treesj',
    dependencies = { 'nvim-treesitter/nvim-treesitter' },
    keys = {
      {
        '<leader>m',
        function()
          require('treesj').toggle()
        end,
        desc = 'treesj: split/join collections',
      },
    },
    opts = {
      max_join_length = 1000,
    },
  },
  {
    'junegunn/vim-easy-align',
    keys = {
      { '<leader>A', '<Plug>(EasyAlign)*', desc = 'align', mode = 'v' },
    },
  },
  {
    'bronson/vim-trailing-whitespace',
    cmd = { 'FixWhitespace' },
  },
  {
    'numToStr/Comment.nvim',
    opts = {
      mappings = false,
    },
    keys = {
      {
        '<c-_>',
        function()
          require('Comment.api').toggle.linewise.current()
        end,
        desc = 'Comment toggle linewise',
      },
      {
        '<c-/>',
        function()
          require('Comment.api').toggle.linewise.current()
        end,
        desc = 'Comment toggle linewise',
      },
      {
        '<c-_>',
        '<ESC><CMD>lua require("Comment.api").locked("toggle.linewise")(vim.fn.visualmode())<CR>',
        desc = 'Comment toggle linewise',
        mode = 'v',
      },
      {
        '<c-/>',
        '<ESC><CMD>lua require("Comment.api").locked("toggle.linewise")(vim.fn.visualmode())<CR>',
        desc = 'Comment toggle linewise',
        mode = 'v',
      },
    },
  },
  {
    'kylechui/nvim-surround',
    version = '*',
    opts = {
      keymaps = {
        insert = false,
        insert_line = false,
        normal = false,
        normal_cur = false,
        normal_line = false,
        normal_cur_line = false,
        visual = false,
        visual_line = false,
        delete = false,
        change = false,
        change_line = false,
      },
    },
    keys = {
      { '<leader>sa', '<Plug>(nvim-surround-normal)iw', desc = 'surround add: [char]' },
      { '<leader>sd', '<Plug>(nvim-surround-delete)', desc = 'surround delete: [char]' },
      { '<leader>sr', '<Plug>(nvim-surround-change)', desc = 'surround replace: [from][to]' },
      { '<leader>sa', '<Plug>(nvim-surround-visual)', desc = 'surround add: [char]', mode = 'v' },
    },
  },
}
