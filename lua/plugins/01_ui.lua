return {
  {
    'neanias/everforest-nvim',
    event = 'VeryLazy',
    config = function()
      require('everforest').setup({
        italic = false,
        disable_italic_comments = true,
        on_highlights = function(hl, palette)
          hl.LineNr = { fg = '#C0D4C0' }
          hl.Comment = { fg = '#50B010' }
        end,
      })
      vim.cmd('colorscheme everforest')
    end,
  },
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    opts = {
      input = {
        enabled = true,
      },
      picker = {
        enabled = true,
        ui_select = true,
      },
    },
    keys = {
      {
        '<leader>:',
        function()
          require('snacks').picker.commands()
        end,
        desc = 'Command picker',
      },
      {
        '<leader><space>',
        function()
          require('snacks').picker.buffers()
        end,
        desc = 'Find existing buffers',
      },
      {
        '<leader>p',
        function()
          require('snacks').picker.files()
        end,
        desc = 'search file',
      },
      {
        '<leader>sg',
        function()
          require('snacks').picker.grep()
        end,
        desc = 'Search by Grep',
      },
      {
        '<leader>P',
        function()
          require('snacks').picker.pickers()
        end,
        desc = 'Search by Grep',
      },
    },
  },
  {
    'lukas-reineke/indent-blankline.nvim',
    main = 'ibl',
    config = function() ---@diagnostic disable-line
      local highlight = {
        'RainbowRed',
        'RainbowYellow',
        'RainbowBlue',
        'RainbowOrange',
        'RainbowGreen',
        'RainbowViolet',
        'RainbowCyan',
      }

      local hooks = require('ibl.hooks')
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, 'RainbowRed', { fg = '#C06C75' })
        vim.api.nvim_set_hl(0, 'RainbowYellow', { fg = '#C5C07B' })
        vim.api.nvim_set_hl(0, 'RainbowBlue', { fg = '#61AAEF' })
        vim.api.nvim_set_hl(0, 'RainbowOrange', { fg = '#C19A66' })
        vim.api.nvim_set_hl(0, 'RainbowGreen', { fg = '#68C379' })
        vim.api.nvim_set_hl(0, 'RainbowViolet', { fg = '#A678D0' })
        vim.api.nvim_set_hl(0, 'RainbowCyan', { fg = '#16B6C0' })
      end)

      require('ibl').setup({
        indent = {
          highlight = highlight,
          char = '▏',
        },
      })
    end,
  },
  {
    'yamatsum/nvim-cursorline',
    opts = {
      cursorline = {
        enable = false,
      },
    },
  },
  {
    'folke/which-key.nvim',
    event = 'VimEnter',
    opts = {
      expand = 1,
      spec = {
        {
          '<leader>cd',
          function()
            vim.cmd(':tcd ' .. vim.fn.expand('%:p:h'))
          end,
          desc = 'change directory of current file',
        },
        {
          '<leader>ce',
          function()
            vim.cmd(':tabnew ~/.config/nvim/init.lua')
            vim.cmd(':tcd ~/.config/nvim')
          end,
          desc = 'edit neovim config',
        },
        { '<leader>s', group = 'Search or surround' },
        { '<leader>s_', hidden = true },
        {
          '<leader>e',
          function()
            vim.diagnostic.open_float({
              suffix = function(diagnostic)
                local utils = require('utils')
                local href = utils.dig(diagnostic, { 'user_data', 'lsp', 'codeDescription', 'href' })
                if href == '' then
                  return string.format(' (%s: %s)', diagnostic.source, diagnostic.code), ''
                else
                  return string.format(' (%s: %s, %s)', diagnostic.source, diagnostic.code, href), ''
                end
              end,
            })
          end,
          desc = 'Open floating diagnostic message',
        },
        {
          '<leader>q',
          function()
            require('snacks').picker.diagnostics_buffer()
          end,
          desc = 'Open diagnostics list',
        },
        {
          '<leader>y',
          expr = true,
          group = 'Yank',
          replace_keycodes = false,
        },
        {
          '<leader>ya',
          function()
            vim.fn.setreg('+', vim.fn.expand('%:p'))
          end,
          desc = 'clipboard: copy file absolute path',
        },
        {
          '<leader>yf',
          function()
            vim.fn.setreg('+', vim.fn.expand('%:t'))
          end,
          desc = 'clipboard: copy current file name',
        },
        {
          '<leader>yr',
          function()
            vim.fn.setreg('+', vim.fn.expand('%'))
          end,
          desc = 'clipboard: copy file relative path',
        },
        {
          '<leader>yy',
          function()
            vim.cmd('%y+')
          end,
          desc = 'copy entire file to clipboard',
        },
        { '<leader>b', group = 'Buffer' },
        { '<leader>bc', group = 'Buffer Clear' },
        { '<leader>d', group = 'Debug' },
        { '<leader>g', group = 'Git' },
        { '<leader>l', group = 'LSP' },
        { '<leader>r', group = 'Bookmark' },
        {
          '<leader>u',
          function()
            local uri = vim.fn.expand('<cWORD>')
            local pattern = '[%w-]+:.*'
            if string.match(uri, pattern) then
              vim.ui.open(uri)
            else
              vim.notify('not uri')
            end
          end,
          desc = 'open uri',
        },
      },
    },
  },
  {
    'folke/todo-comments.nvim',
    event = 'BufEnter',
    version = '*',
    config = function()
      require('todo-comments').setup({
        signs = false,
      })
      for name, _ in pairs(vim.api.nvim_get_commands({ builtin = false })) do
        if name:find('Todo') then
          vim.api.nvim_del_user_command(name)
        end
      end
    end,
  },
}
