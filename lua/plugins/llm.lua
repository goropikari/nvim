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
    },
    cmd = { 'CopilotChat' },
    keys = {
      {
        '<leader>gcc',
        function()
          vim.cmd('CopilotChat')
        end,
        desc = 'CopilotChat - Quick chat',
      },
    },
  },
  os.getenv('COMPANY_LLM_PLUGIN_PATH') and {
    dir = os.getenv('COMPANY_LLM_PLUGIN_PATH'),
    opts = {},
  },
}
