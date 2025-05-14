local utils = require('utils')

return {
  {
    'github/copilot.vim',
    version = '*',
    event = 'BufEnter',
    cond = os.getenv('DISABLE_COPILOT') ~= '1',
  },
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    version = '*',
    cond = os.getenv('DISABLE_COPILOT') ~= '1',
    dependencies = {
      { 'github/copilot.vim' },
      { 'nvim-lua/plenary.nvim' }, -- for curl, log wrapper
    },
    build = 'make tiktoken', -- Only on MacOS or Linux
    opts = {
      debug = false,
      window = {
        layout = 'vertical',
        width = 0.4,
      },
      -- model = 'claude-3.7-sonnet',
    },
    cmd = { 'CopilotChat' },
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
  os.getenv('COMPANY_LLM_PLUGIN_PATH') and {
    dir = os.getenv('COMPANY_LLM_PLUGIN_PATH'),
    opts = {},
  },
}
