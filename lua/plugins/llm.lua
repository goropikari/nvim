local utils = require('utils')

return {
  {
    'github/copilot.vim',
    enabled = vim.fn.filereadable(os.getenv('HOME') .. '/.config/github-copilot/apps.json') == 1,
  },
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    enabled = vim.fn.filereadable(os.getenv('HOME') .. '/.config/github-copilot/apps.json') == 1,
    branch = 'canary',
    dependencies = {
      { 'github/copilot.vim' },
      { 'nvim-lua/plenary.nvim' }, -- for curl, log wrapper
    },
    build = 'make tiktoken', -- Only on MacOS or Linux
    opts = {
      debug = false,
      window = {
        layout = 'vertical',
        width = 0.15,
      },
    },
    keys = {
      {
        '<leader>gcc',
        function()
          local input = vim.fn.input('Quick Chat: ')
          if input ~= '' then
            require('CopilotChat').ask(input, { selection = require('CopilotChat.select').buffer })
          end
        end,
        desc = 'CopilotChat - Quick chat',
      },
      {
        '<leader>gcs',
        function()
          local input = vim.fn.join(utils.get_visual_lines(), '\n')
          if input ~= '' then
            require('CopilotChat').ask(input, { selection = require('CopilotChat.select').buffer })
          end
        end,
        desc = 'CopilotChat - Send visual lines',
        mode = 'v',
      },
    },
  },
  -- {
  --   'jackMort/ChatGPT.nvim',
  --   enabled = vim.fn.filereadable(os.getenv('HOME') .. '/.config/github-copilot/apps.json') ~= 1,
  --   cmd = { 'ChatGPT' },
  --   opts = {
  --     api_host_cmd = 'echo http://127.0.0.1:11434',
  --     api_key_cmd = 'echo dummy_api_key',
  --     openai_params = {
  --       -- model = 'codellama',
  --       -- model = 'codegemma',
  --       -- model = 'qwen2.5-coder',
  --       -- model = 'llama-3-elyza-jp:8b',
  --       -- model = 'codellama:7b-instruct-q8_0',
  --       model = 'codegemma:7b-instruct-v1.1-q8_0',
  --     },
  --   },
  --   dependencies = {
  --     'MunifTanjim/nui.nvim',
  --     'nvim-lua/plenary.nvim',
  --     'folke/trouble.nvim',
  --     'nvim-telescope/telescope.nvim',
  --   },
  -- },
  -- {
  --   'olimorris/codecompanion.nvim',
  --   enabled = vim.fn.filereadable(os.getenv('HOME') .. '/.config/github-copilot/apps.json') ~= 1,
  --   cmd = { 'CodeCompanionChat' },
  --   dependencies = {
  --     'nvim-lua/plenary.nvim',
  --     'nvim-treesitter/nvim-treesitter',
  --     'hrsh7th/nvim-cmp', -- Optional: For using slash commands and variables in the chat buffer
  --     -- 'nvim-telescope/telescope.nvim', -- Optional: For using slash commands
  --     -- { 'stevearc/dressing.nvim', opts = {} }, -- Optional: Improves `vim.ui.select`
  --   },
  --   opts = {
  --     adapters = {
  --       codellama = function()
  --         return require('codecompanion.adapters').extend('ollama', {
  --           name = 'codellama', -- Give this adapter a different name to differentiate it from the default ollama adapter
  --           schema = {
  --             model = {
  --               default = 'codegemma',
  --             },
  --             -- num_ctx = {
  --             --   default = 16384,
  --             -- },
  --             -- num_predict = {
  --             --   default = -1,
  --             -- },
  --           },
  --         })
  --       end,
  --       codegemma = function()
  --         return require('codecompanion.adapters').extend('ollama', {
  --           name = 'codegemma',
  --           schema = {
  --             model = {
  --               default = 'codegemma:7b-instruct-v1.1-q8_0',
  --             },
  --             num_ctx = {
  --               default = 2048,
  --             },
  --           },
  --         })
  --       end,
  --       qwen = function()
  --         return require('codecompanion.adapters').extend('ollama', {
  --           name = 'codegemma',
  --           schema = {
  --             model = {
  --               default = 'qwen2.5-coder',
  --             },
  --           },
  --         })
  --       end,
  --     },
  --     strategies = {
  --       chat = {
  --         adapter = 'codegemma',
  --       },
  --       inline = {
  --         adapter = 'codegemma',
  --       },
  --       agent = {
  --         adapter = 'codegemma',
  --       },
  --     },
  --   },
  -- },
  {
    'goropikari/ollama.nvim',
    dev = true,
    opts = {},
    cmd = { 'OllamaChat' },
  },
  os.getenv('COMPANY_LLM_PLUGIN_PATH') and {
    dir = os.getenv('COMPANY_LLM_PLUGIN_PATH'),
    opts = {},
  },
}
