return {
  {
    -- colorscheme
    'ellisonleao/gruvbox.nvim',
    event = 'VeryLazy',
    opts = {
      italic = {
        strings = false,
        emphasis = false,
        comments = false,
        operators = false,
        folds = true,
      },
      undercurl = true,
      underline = true,
      bold = false,
      overrides = {
        LineNr = { fg = '#C0D4C0' }, -- line number の色を変える
        Comment = { fg = '#50B010' }, -- comment の色を変える
      },
    },
    config = function(plugin, opts)
      require('gruvbox').setup(opts)
      vim.cmd('colorscheme gruvbox')
    end,
  },
  {
    -- hex を色を付けて表示する
    -- :ColorizerToggle で有効になる
    'norcalli/nvim-colorizer.lua',
    cmd = { 'ColorizerToggle' },
  },
  {
    -- sidebar file explorer
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x',
    -- cmd = 'Neotree',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
      'MunifTanjim/nui.nvim',
      -- "3rd/image.nvim", -- Optional image support in preview window: See `# Preview Mode` for more information
    },
    keys = {
      {
        '<c-e>', -- Ctrl-e で neo-tree の表示切り替え
        function()
          require('neo-tree.command').execute({ toggle = true })
        end,
        desc = 'Explorer NeoTree',
      },
    },
    deactivate = function()
      vim.cmd([[Neotree close]])
    end,
    init = function()
      if vim.fn.argc(-1) == 1 then
        local stat = vim.loop.fs_stat(vim.fn.argv(0))
        if stat and stat.type == 'directory' then
          require('neo-tree')
        end
      end
    end,
    opts = {
      sources = { 'filesystem', 'buffers', 'git_status', 'document_symbols' },
      open_files_do_not_replace_types = { 'terminal', 'Trouble', 'trouble', 'qf', 'Outline' },
      hijack_netrw_behavior = 'disabled',
      filesystem = {
        bind_to_cwd = false,
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
        filtered_items = {
          hide_dotfiles = false,
        },
      },
      window = {
        position = 'float',
        mappings = {
          ['<space>'] = 'none',
          ['Y'] = function(state)
            local node = state.tree:get_node()
            local path = node:get_id()
            vim.fn.setreg('+', path, 'c')
          end,
        },
      },
      default_component_configs = {
        indent = {
          with_expanders = true, -- if nil and file nesting is enabled, will enable expanders
          expander_collapsed = '',
          expander_expanded = '',
          expander_highlight = 'NeoTreeExpander',
        },
      },
    },
  },
  {
    -- Fuzzy Finder (files, lsp, etc)
    'nvim-telescope/telescope.nvim',
    event = 'VeryLazy',
    branch = '0.1.x',
    dependencies = {
      'folke/which-key.nvim',
      'nvim-lua/plenary.nvim',
      -- Fuzzy Finder Algorithm which requires local dependencies to be built.
      -- Only load if `make` is available. Make sure you have the system
      -- requirements installed.
      {
        'nvim-telescope/telescope-fzf-native.nvim',
        -- NOTE: If you are having trouble with this installation,
        --       refer to the README for telescope-fzf-native for more instructions.
        build = 'make',
        cond = function()
          return vim.fn.executable('make') == 1
        end,
      },
    },
    config = function()
      -- local actions = require('telescope.actions')
      require('telescope').setup({
        -- defaults = {
        --   mappings = {
        --     i = {
        --       ['<c-CR>'] = actions.select_default,
        --       ['<CR>'] = actions.nop,
        --     },
        --     n = {
        --       ['<c-CR>'] = actions.select_default,
        --       ['<CR>'] = actions.nop,
        --     },
        --   },
        -- },
      })

      -- Enable telescope fzf native, if installed
      pcall(require('telescope').load_extension, 'fzf')
    end,
    keys = {
      {
        '<leader>?',
        function()
          require('telescope.builtin').oldfiles()
        end,
        desc = '[?] Find recently opened files',
      },
      {
        '<leader><space>',
        function()
          require('telescope.builtin').buffers()
        end,
        desc = '[ ] Find existing buffers',
      },
      {
        '<leader>/',
        function()
          -- You can pass additional configuration to telescope to change theme, layout, etc.
          require('telescope.builtin').current_buffer_fuzzy_find(require('telescope.themes').get_dropdown({
            winblend = 10,
            previewer = false,
          }))
        end,
        desc = '[/] Fuzzily search in current buffer',
      },
      {
        '<leader>p',
        function()
          require('telescope.builtin').find_files({ hidden = true, file_ignore_patterns = { '.git/' } })
        end,
        desc = 'search file',
      },
      {
        '<leader>sb',
        function()
          require('telescope.builtin').current_buffer_fuzzy_find()
        end,
        desc = 'Search current Buffer',
      },
      {
        '<leader>ss',
        function()
          require('telescope.builtin').builtin()
        end,
        desc = 'Search Select Telescope',
      },
      {
        '<leader>gf',
        function()
          require('telescope.builtin').git_files()
        end,
        desc = 'Search Git Files',
      },
      {
        '<leader>gs',
        function()
          require('telescope.builtin').git_status()
        end,
        desc = 'Search Git Status',
      },
      {
        '<leader>sf',
        function()
          require('telescope.builtin').find_files()
        end,
        desc = 'Search Files',
      },
      {
        '<leader>sh',
        function()
          require('telescope.builtin').help_tags()
        end,
        desc = 'Search Help',
      },
      {
        '<leader>sw',
        function()
          require('telescope.builtin').grep_string()
        end,
        desc = 'Search current Word',
      },
      {
        '<leader>sg',
        function()
          require('telescope.builtin').live_grep()
        end,
        desc = 'Search by Grep',
      },
      -- {
      --   '<leader>sd',
      --   function()
      --     require('telescope.builtin').diagnostics()
      --   end,
      --   desc = 'Search Diagnostics',
      -- },
    },
  },
  {
    -- Set lualine as statusline
    'nvim-lualine/lualine.nvim',
    event = 'VimEnter',
    -- dependencies = {
    --   dir = vim.fn.stdpath('config') .. '/lua/custom/plugins/codecompanion-lualine',
    -- },
    opts = {
      options = {
        icons_enabled = true,
        theme = 'wombat',
        component_separators = '|',
        section_separators = '',
      },
      sections = {
        lualine_c = {
          {
            'filename',
            path = 3,
          },
        },
        lualine_x = {
          {
            'codecompanion',
          },
        },
      },
    },
  },
  {
    -- Highly experimental plugin that completely replaces the UI for messages, cmdline and the popupmenu.
    -- command が pop up window で表示される
    'folke/noice.nvim',
    event = 'VeryLazy',
    opts = {
      lsp = {
        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
        override = {
          ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
          ['vim.lsp.util.stylize_markdown'] = true,
          ['cmp.entry.get_documentation'] = true, -- requires hrsh7th/nvim-cmp
        },
      },
      -- you can enable a preset for easier configuration
      presets = {
        bottom_search = false, -- use a classic bottom cmdline for search
        command_palette = true, -- position the cmdline and popupmenu together
        long_message_to_split = true, -- long messages will be sent to a split
        inc_rename = false, -- enables an input dialog for inc-rename.nvim
        lsp_doc_border = false, -- add a border to hover docs and signature help
      },
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      'MunifTanjim/nui.nvim',
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      -- "rcarriga/nvim-notify",
    },
    keys = {
      {
        '<leader>nh',
        function()
          require('noice').cmd('history')
        end,
        desc = 'Noice History',
      },
      {
        '<leader>ne',
        function()
          require('noice').cmd('error')
        end,
        desc = 'Noice Error',
      },
      {
        '<leader>nl',
        function()
          require('noice').cmd('last')
        end,
        desc = 'Noice Last',
      },
    },
  },
  {
    -- vim.ui.input を cursor で選択できるようにする
    'stevearc/dressing.nvim',
    event = 'VimEnter',
    opts = {},
  },
  {
    'goropikari/bookmarks.nvim',
    dev = true,
    dependencies = {
      'nvim-telescope/telescope.nvim',
    },
    opts = {
      save_file = nil,
    },
    keys = {
      {
        '<leader>ra',
        function()
          require('bookmarks').bookmark_toggle()
        end,
        desc = 'bookmark toggle',
      },
      {
        '<leader>rcc',
        function()
          require('bookmarks').bookmark_clean()
        end,
        desc = 'bookmark clear at current buffer',
      },
      {
        '<leader>rca',
        function()
          require('bookmarks').bookmark_clear_all()
        end,
        desc = 'bookmark clear all',
      },
      {
        '<leader>rl',
        function()
          require('telescope').extensions.bookmarks.list()
        end,
        desc = 'bookmark list',
      },
    },
    build = function()
      vim.system({ 'mkdir', '-p', vim.fn.stdpath('state') .. '/bookmarks.nvim' })
    end,
  },
  {
    -- buffer を tab で表示する
    'romgrk/barbar.nvim',
    event = 'VeryLazy',
    dependencies = {
      'lewis6991/gitsigns.nvim', -- OPTIONAL: for git status
      'nvim-tree/nvim-web-devicons', -- OPTIONAL: for file icons
    },
    init = function()
      vim.g.barbar_auto_setup = false
    end,
    opts = {
      animation = false,
    },
    version = '^1.0.0', -- optional: only update when a new 1.x version is released
    keys = {
      { '<leader>bn', '<Cmd>BufferNext<CR>', desc = 'Buffer Next' },
      { '<leader>bN', '<Cmd>BufferPrevious<CR>', desc = 'Buffer Previous' },
      { '<leader>bca', '<Cmd>BufferCloseAllButCurrent<CR><C-w><C-o><CR>', desc = 'close all buffer but current' },
      { '<leader>bcc', '<Cmd>BufferClose<CR><Cmd>q<CR>', desc = 'close buffer' },
    },
  },
  {
    -- Highlight, edit, and navigate code
    'nvim-treesitter/nvim-treesitter',
    event = 'VeryLazy',
    dependencies = {
      'nvim-treesitter/nvim-treesitter-textobjects',
    },
    build = ':TSUpdate',
    config = function()
      -- [[ Configure Treesitter ]]
      -- See `:help nvim-treesitter`
      -- Defer Treesitter setup after first render to improve startup time of 'nvim {filename}'
      vim.defer_fn(function()
        require('nvim-treesitter.configs').setup({
          -- Add languages to be installed here that you want installed for treesitter
          ensure_installed = { 'c', 'cpp', 'go', 'lua', 'python', 'vimdoc', 'vim', 'bash', 'ruby', 'json' },

          -- Autoinstall languages that are not installed. Defaults to false (but you can change for yourself!)
          auto_install = false,
          -- Install languages synchronously (only applied to `ensure_installed`)
          sync_install = false,
          -- List of parsers to ignore installing
          ignore_install = {},
          -- You can specify additional Treesitter modules here: -- For example: -- playground = {--enable = true,-- },
          modules = {},
          highlight = { enable = true },
          indent = { enable = true },
          incremental_selection = {
            enable = false,
            keymaps = {
              init_selection = '<c-space>',
              node_incremental = '<c-space>',
              scope_incremental = '<c-s>',
              node_decremental = '<M-space>',
            },
          },
          textobjects = {
            select = {
              enable = false,
              lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
              keymaps = {
                -- You can use the capture groups defined in textobjects.scm
                ['aa'] = '@parameter.outer',
                ['ia'] = '@parameter.inner',
                ['af'] = '@function.outer',
                ['if'] = '@function.inner',
                ['ac'] = '@class.outer',
                ['ic'] = '@class.inner',
              },
            },
            move = {
              enable = true,
              set_jumps = true, -- whether to set jumps in the jumplist
              goto_next_start = {
                [']m'] = '@function.outer',
                [']]'] = '@class.outer',
              },
              goto_next_end = {
                [']M'] = '@function.outer',
                [']['] = '@class.outer',
              },
              goto_previous_start = {
                ['[m'] = '@function.outer',
                ['[['] = '@class.outer',
              },
              goto_previous_end = {
                ['[M'] = '@function.outer',
                ['[]'] = '@class.outer',
              },
            },
            swap = {
              enable = false,
              swap_next = {
                ['<leader>a'] = '@parameter.inner',
              },
              swap_previous = {
                ['<leader>A'] = '@parameter.inner',
              },
            },
          },
        })
      end, 0)
    end,
  },
  {
    -- indent を見やすくする
    'shellRaining/hlchunk.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
      chunk = {
        enable = true,
      },
      indent = {
        enable = true,
        chars = {
          '│',
        },
        style = {
          '#C06C75',
          '#C5C07B',
          '#61AAEF',
          '#C19A66',
          '#68C379',
          '#A678D0',
          '#16B6C0',
        },
      },
    },
  },
  -- {
  --   -- indent を見やすくする
  --   'lukas-reineke/indent-blankline.nvim',
  --   main = 'ibl',
  --   ---@module "ibl"
  --   ---@type ibl.config
  --   config = function()
  --     local highlight = {
  --       'RainbowRed',
  --       'RainbowYellow',
  --       'RainbowBlue',
  --       'RainbowOrange',
  --       'RainbowGreen',
  --       'RainbowViolet',
  --       'RainbowCyan',
  --     }
  --
  --     local hooks = require('ibl.hooks')
  --     -- create the highlight groups in the highlight setup hook, so they are reset
  --     -- every time the colorscheme changes
  --     hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
  --       vim.api.nvim_set_hl(0, 'RainbowRed', { fg = '#C06C75' })
  --       vim.api.nvim_set_hl(0, 'RainbowYellow', { fg = '#C5C07B' })
  --       vim.api.nvim_set_hl(0, 'RainbowBlue', { fg = '#61AAEF' })
  --       vim.api.nvim_set_hl(0, 'RainbowOrange', { fg = '#C19A66' })
  --       vim.api.nvim_set_hl(0, 'RainbowGreen', { fg = '#68C379' })
  --       vim.api.nvim_set_hl(0, 'RainbowViolet', { fg = '#A678D0' })
  --       vim.api.nvim_set_hl(0, 'RainbowCyan', { fg = '#16B6C0' })
  --     end)
  --
  --     require('ibl').setup({
  --       indent = {
  --         highlight = highlight,
  --         char = '▏',
  --       },
  --     })
  --   end,
  -- },
  {
    -- cursor 下と同じ文字列に下線を引く'
    'yamatsum/nvim-cursorline',
    opts = {
      cursorline = {
        enable = false,
      },
    },
  },
  {
    -- splitting/joining blocks of code like arrays, hashes, statements, objects, dictionaries, etc.
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
    -- :FixWhitespace で末端空白を消す
    'bronson/vim-trailing-whitespace',
    cmd = { 'FixWhitespace' },
  },
  {
    -- Ctrl-/ でコメント
    'numToStr/Comment.nvim',
    opts = {
      mappings = false,
    },
    keys = {
      -- terminal によって Ctrl-/ を Ctrl-_ に認識することがある。逆もしかり
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
    -- Add/delete/change surrounding pairs
    'kylechui/nvim-surround',
    version = '*', -- Use for stability; omit to use `main` branch for the latest features
    opts = {
      keymaps = {
        -- default keymap を無効化
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
  {
    -- Git related plugins
    'tpope/vim-fugitive',
    event = 'VeryLazy',
  },
  {
    -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    event = 'VeryLazy',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
    keys = {
      { '<leader>g', desc = 'Git' },
      {
        '<leader>ga',
        function()
          require('gitsigns').stage_hunk({ vim.fn.line('.'), vim.fn.line('v') })
        end,
        desc = 'stage git hunk',
        mode = 'v',
      },
    },
  },
  {
    -- github review
    'pwntester/octo.nvim',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-telescope/telescope.nvim',
      'nvim-tree/nvim-web-devicons',
    },
    opts = {
      mappings_disable_default = false,
    },
    cmd = { 'Octo' },
  },
  {
    -- Autocompletion
    'hrsh7th/nvim-cmp',
    event = 'InsertEnter',
    dependencies = {
      -- Snippet Engine & its associated nvim-cmp source
      {
        'L3MON4D3/LuaSnip',
        build = (function()
          -- Build Step is needed for regex support in snippets
          -- This step is not supported in many windows environments
          -- Remove the below condition to re-enable on windows
          if vim.fn.has('win32') == 1 then
            return
          end
          return 'make install_jsregexp'
        end)(),
      },
      'saadparwaiz1/cmp_luasnip',

      -- Adds LSP completion capabilities
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/cmp-path',

      -- Adds a number of user-friendly snippets
      'rafamadriz/friendly-snippets',

      -- neovim lua
      {
        'folke/lazydev.nvim',
        ft = 'lua', -- only load on lua files
        opts = {
          library = {
            -- See the configuration section for more details
            -- Load luvit types when the `vim.uv` word is found
            { path = 'luvit-meta/library', words = { 'vim%.uv' } },
          },
        },
      },
      { 'Bilal2453/luvit-meta', lazy = true }, -- optional `vim.uv` typings
    },
    config = function()
      local cmp = require('cmp')
      local luasnip = require('luasnip')
      -- require('luasnip.loaders.from_vscode').lazy_load()
      -- luasnip.config.setup({})

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        completion = {
          completeopt = 'menu,menuone,noinsert',
        },
        mapping = cmp.mapping.preset.insert({
          ['<C-n>'] = cmp.mapping.select_next_item(),
          -- ['<C-p>'] = cmp.mapping.select_prev_item(),
          -- ['<C-b>'] = cmp.mapping.scroll_docs(-4),
          -- ['<C-f>'] = cmp.mapping.scroll_docs(4),
          -- ['<C-Space>'] = cmp.mapping.complete {},
          ['<CR>'] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
          }),
          ['<Tab>'] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif luasnip.expand_or_locally_jumpable() then
              luasnip.expand_or_jump()
            else
              fallback()
            end
          end, { 'i', 's' }),
          -- ['<S-Tab>'] = cmp.mapping(function(fallback)
          --   if cmp.visible() then
          --     cmp.select_prev_item()
          --   elseif luasnip.locally_jumpable(-1) then
          --     luasnip.jump(-1)
          --   else
          --     fallback()
          --   end
          -- end, { 'i', 's' }),
        }),
        sources = {
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
          { name = 'path' },
          {
            name = 'lazydev',
            group_index = 0, -- set group index to 0 to skip loading LuaLS completions
          },
        },
      })
    end,
  },
  {
    -- Autoformat
    'stevearc/conform.nvim',
    event = { 'BufWritePre' },
    cmd = { 'ConformInfo' },
    keys = {
      {
        '<leader>f',
        function()
          require('conform').format({ async = true, lsp_format = 'fallback' })
        end,
        mode = '',
        desc = 'Format buffer',
      },
    },
    opts = {
      notify_on_error = false,
      format_on_save = function(bufnr)
        -- Disable "format_on_save lsp_fallback" for languages that don't
        -- have a well standardized coding style. You can add additional
        -- languages here or re-enable it for the disabled ones.
        local disable_filetypes = { c = false, cpp = false }
        local lsp_format_opt
        if disable_filetypes[vim.bo[bufnr].filetype] then
          lsp_format_opt = 'never'
        else
          lsp_format_opt = 'fallback'
        end
        return {
          timeout_ms = 500,
          lsp_format = lsp_format_opt,
        }
      end,
      formatters_by_ft = {
        lua = { 'stylua' },
        go = { 'goimports', 'gofumpt' },
      },
    },
  },
  {
    'stevearc/aerial.nvim',
    opts = {},
    -- Optional dependencies
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons',
    },
    keys = {
      {
        '<leader>a',
        function()
          require('aerial').toggle()
        end,
        desc = 'code outline',
      },
    },
  },
  {
    -- 開いている window を番号で選択する
    'goropikari/chowcho.nvim',
    dev = true,
    branch = 'fix',
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    opts = {
      -- Must be a single character. The length of the array is the maximum number of windows that can be moved.
      labels = { 'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L', 'M', 'N', 'O', 'P', 'Q', 'R', 'S', 'T', 'U', 'V', 'W', 'X', 'Y', 'Z' },
      use_exclude_default = true,
      ignore_case = true,
      exclude = function(buf, win)
        -- exclude noice.nvim's cmdline_popup
        local bt = vim.api.nvim_get_option_value('buftype', { buf = buf })
        local ft = vim.api.nvim_get_option_value('filetype', { buf = buf })
        if bt == 'nofile' and (ft == 'noice' or ft == 'vim') then
          return true
        end
        return false
      end,
      selector_style = 'float',
      selector = {
        float = {
          border_style = 'rounded',
          icon_enabled = true,
          color = {
            label = { active = '#c8cfff', inactive = '#ababab' },
            text = { active = '#fefefe', inactive = '#d0d0d0' },
            border = { active = '#b400c8', inactive = '#fefefe' },
          },
          zindex = 1,
        },
        statusline = {
          color = {
            label = { active = '#fefefe', inactive = '#d0d0d0' },
            background = { active = '#3d7172', inactive = '#203a3a' },
          },
        },
      },
    },
    keys = {
      {
        '<leader>CC',
        function()
          require('chowcho').run()
        end,
        desc = 'choose window',
      },
    },
  },
  {
    -- Ctrl-t でターミナルを出す
    'akinsho/toggleterm.nvim',
    dependencies = {
      'nvim-telescope/telescope.nvim',
      -- toggleterm で開いた terminal を telescope で検索する
      'tknightz/telescope-termfinder.nvim',
    },
    version = '*',
    cmd = { 'ToggleTerm' },
    -- opts = {
    --   open_mapping = [[<c-\>]],
    --   direction = 'float',
    --   winbar = {
    --     enabled = true,
    --     name_formatter = function(term) --  term: Terminal
    --       return term.name
    --     end,
    --   },
    -- },
    keys = {
      {
        '<c-t>',
        function()
          vim.cmd('ToggleTerm')
        end,
        mode = { 'n', 't' },
      },
      {
        '<leader>st',
        function()
          vim.cmd([[Telescope termfinder find]])
        end,
        desc = 'Search ToggleTerm',
      },
    },
    config = function()
      require('toggleterm').setup({
        open_mapping = [[<c-\>]],
        direction = 'float',
        -- direction = 'horizontal',
        -- winbar = {
        --   enabled = true,
        --   name_formatter = function(term) --  term: Terminal
        --     return term.name
        --   end,
        -- },
      })
      require('telescope').load_extension('termfinder')
    end,
  },
  {
    -- Useful plugin to show you pending keybinds.
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
            -- vim.cmd('Neotree show')
          end,
          desc = 'edit neovim config',
        },

        -- document existing key chains
        { '<leader>s', group = 'Search or surround' },
        { '<leader>s_', hidden = true },

        -- Diagnostic keymaps
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
        { '<leader>q', vim.diagnostic.setloclist, desc = 'Open diagnostics list' },

        -- clipboard へコピー
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

        -- [[ Noice ]]
        { '<leader>n', desc = 'Noice' },

        -- [[ barbar.nvim ]]
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
              vim.system({ 'xdg-open', uri })
            else
              vim.notify('not uri')
            end
          end,
          desc = 'open uri',
        },

        -- {
        --   '<leader>w',
        --   function()
        --     vim.cmd('w') -- ファイルを保存 (:w)
        --     if vim.bo.filetype == 'lua' then
        --       vim.cmd('source') -- カレントファイルを再読み込み (:source)
        --     end
        --   end,
        --   desc = 'write & source',
        -- },
      },
    },
  },
  {
    -- Highlight todo, notes, etc in comments
    'folke/todo-comments.nvim',
    event = 'VimEnter',
    dependencies = { 'nvim-lua/plenary.nvim' },
    -- opts = { signs = false },
    config = function()
      require('todo-comments').setup({
        signs = false,
      })
      -- command 必要ないので削除
      for name, _ in pairs(vim.api.nvim_get_commands({ builtin = false })) do
        if name:find('Todo') then
          vim.api.nvim_del_user_command(name)
        end
      end
    end,
  },
  {
    -- avoid nested neovim session
    'willothy/flatten.nvim',
    opts = {},
  },
  {
    -- google 検索
    'voldikss/vim-browser-search',
    keys = {
      { '<leader>w', '<Plug>SearchVisual', 'google select word', mode = 'v' },
      { '<leader>w', '<Plug>SearchNormal', 'google select word', mode = 'n' },
    },
  },
  {
    'goropikari/jnv.nvim',
    dev = true,
    dependencies = {
      'nvim-telescope/telescope.nvim',
    },
    opts = {
      window = {
        layout = 'vertical',
      },
    },
    keys = {
      {
        '<leader>jn',
        function()
          require('jnv').jnv_current_buffer()
        end,
        desc = 'open jnv',
      },
      {
        '<leader>jn',
        function()
          require('jnv').jnv_selection()
        end,
        mode = 'v',
        desc = 'open jnv',
      },
      {
        '<leader>jt',
        function()
          require('telescope').extensions.jnv.jnv()
        end,
        mode = 'n',
        desc = 'list jnv buffer',
      },
    },
  },
  {
    'goropikari/local-devcontainer.nvim',
    dev = true,
    enabled = vim.fn.executable('devcontainer') == 1,
    cmd = { 'DevContainerUp' },
    opts = {
      devcontainer = {
        args = {
          '--workspace-folder=.',
          -- '--skip-non-blocking-commands',
          -- '--remove-existing-container',
          -- '--skip-post-attach=true',
          -- '--skip-post-create=true',
          '--mount',
          'type=bind,source=' .. vim.fn.getcwd() .. ',target=/workspaces/' .. vim.fn.expand('%:p:h:t'),
          '--mount',
          'type=bind,source=' .. vim.fn.stdpath('config') .. ',target=/home/vscode/.config/nvim',
          '--mount',
          'type=bind,source=' .. os.getenv('HOME') .. '/.aws,target=/home/vscode/.aws',
          [[--additional-features='{"ghcr.io/goropikari/devcontainer-feature/neovim:1": {}}']],
        },
      },
    },
  },
}
