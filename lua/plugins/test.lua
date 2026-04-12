return {
  {
    'mfussenegger/nvim-dap',
    -- version = '*',
    commit = 'e47878dcf1ccc30136b30d19ab19fe76946d61cd',
    dependencies = {
      -- Creates a beautiful debugger UI
      'rcarriga/nvim-dap-ui',
      'nvim-neotest/nvim-nio',
      {
        -- code 中に変数の値を表示する
        'theHamsta/nvim-dap-virtual-text',
        opts = {},
      },
    },
    config = function()
      local dap = require('dap')
      local dapui = require('dapui')
      dapui.setup()
      dap.listeners.after.event_initialized['dapui_config'] = dapui.open
      dap.listeners.before.event_terminated['dapui_config'] = dapui.close
      dap.listeners.before.event_exited['dapui_config'] = dapui.close
    end,
    keys = {
      { '<leader>d', desc = 'Debug' },
      {
        '<leader>dC',
        function()
          require('dap').clear_breakpoints()
        end,
        desc = 'Debug: Clear Breakpoint',
      },
      {
        '<leader>db',
        function()
          require('dap').toggle_breakpoint()
        end,
        desc = 'Debug: Toggle Breakpoint',
      },
      {
        '<leader>dc',
        function()
          require('dap').toggle_breakpoint(vim.fn.input('debug condition: '))
        end,
        desc = 'Debug: Toggle Conditional Breakpoint',
      },
      {
        '<leader>duc',
        function()
          require('dapui').close()
        end,
        desc = 'Close DAP UI',
      },
      {
        '<F5>',
        function()
          require('dap').continue()
        end,
        desc = 'Debug: Continue',
      },
      {
        '<F10>',
        function()
          require('dap').step_over()
        end,
        desc = 'Debug: Step over',
      },
    },
  },
  {
    'goropikari/nvim-dap-golang',
    dev = true,
    dependencies = {
      'mfussenegger/nvim-dap',
    },
    ft = { 'go' },
    enabled = vim.fn.executable('go') == 1,
    opts = {},
  },
  {
    'mfussenegger/nvim-dap-python',
    dependencies = {
      'mfussenegger/nvim-dap',
    },
    lazy = true,
    ft = { 'python' },
    enabled = vim.fn.executable('python3') == 1,
    config = function()
      require('dap-python').setup('python')
    end,
  },
  {
    'goropikari/nvim-dap-rdbg',
    dev = true,
    dependencies = {
      'mfussenegger/nvim-dap',
    },
    lazy = true,
    ft = { 'ruby' },
    enabled = vim.fn.executable('ruby') == 1,
    opts = {
      configurations = {
        {
          type = 'rdbg',
          name = 'Ruby Debugger: Current File (bundler)',
          request = 'launch',
          command = 'ruby',
          script = '${file}',
          use_bundler = true,
        },
      },
    },
  },
  {
    'goropikari/nvim-dap-cpp',
    dev = true,
    dependencies = {
      'mfussenegger/nvim-dap',
      'nvim-lua/plenary.nvim',
    },
    lazy = true,
    ft = { 'c', 'cpp' },
    enabled = vim.fn.executable('g++') == 1 or vim.fn.executable('gcc') == 1,
    opts = {
      -- configurations = {},
    },
  },
  {
    'nvim-neotest/neotest',
    version = '*',
    dependencies = {
      'nvim-neotest/nvim-nio',
      'nvim-lua/plenary.nvim',
      -- 'antoinemadec/FixCursorHold.nvim',
      'nvim-treesitter/nvim-treesitter',
      {
        'fredrikaverpil/neotest-golang',
        version = 'v2.*',
        enabled = vim.fn.executable('go') == 1,
      },
    },
    keys = {
      { '<leader>t', desc = 'Test' },
      {
        '<leader>ta',
        function()
          ---@diagnostic disable-next-line
          require('neotest').run.run({ vim.fn.expand('%') })
          require('neotest').summary.open()
        end,
        desc = 'Test All',
      },
      {
        '<leader>td',
        function()
          ---@diagnostic disable-next-line
          require('neotest').run.run({ strategy = 'dap' })
        end,
        desc = 'Test Debug',
      },
      {
        '<leader>to',
        function()
          require('neotest').output.open()
        end,
        desc = 'Test Output',
      },
      {
        '<leader>ts',
        function()
          ---@diagnostic disable-next-line
          require('neotest').run.run({})
          require('neotest').summary.open()
        end,
        desc = 'Test Single',
      },
    },
    config = function()
      local neotest_ns = vim.api.nvim_create_namespace('neotest')
      vim.diagnostic.config({
        virtual_text = {
          format = function(diagnostic)
            local message = diagnostic.message:gsub('\n', ' '):gsub('\t', ' '):gsub('%s+', ' '):gsub('^%s+', '')
            return message
          end,
        },
      }, neotest_ns)

      local git_dir_path = vim.fs.find('.git', {
        path = vim.fn.expand('%:p:h'),
        upward = true,
        type = 'directory',
      })

      local root_dirname = vim.fn.expand('%:p:h:t')
      if git_dir_path and #git_dir_path > 0 then
        root_dirname = vim.fn.fnamemodify(git_dir_path[1], ':h:t')
      end

      local langs = {
        {
          executable = 'go',
          plugin_name = 'neotest-golang',
          opts = {
            runner = 'gotestsum',
            go_test_args = { '--shuffle=on' },
            testify_enabled = true,
            env = { DB_NAME = root_dirname .. '_test' },
          },
        },
      }
      local adapters = {}
      for _, v in pairs(langs) do
        if vim.fn.executable(v.executable) == 1 then
          table.insert(adapters, require(v.plugin_name)(v.opts))
        end
      end

      ---@diagnostic disable-next-line
      require('neotest').setup({
        diagnostic = {
          enabled = true,
          severity = 4,
        },
        status = {
          enabled = true,
          signs = true,
          virtual_text = true,
        },
        output = {
          enabled = true,
          open_on_run = true,
        },

        -- your neotest config here
        adapters = adapters,
        log_level = vim.log.levels.WARN,
      })
    end,
  },
  {
    'goropikari/pict.nvim',
    dev = true,
    ft = { 'pict' },
    opts = {},
    keys = {
      {
        '<leader>tp',
        function()
          require('pict').markdown()
        end,
        desc = 'pict',
      },
    },
  },
}
