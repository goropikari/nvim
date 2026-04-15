return {
  {
    'goropikari/ollama-completion.nvim',
    event = 'InsertEnter',
    cond = os.getenv('ENABLE_OLLAMA_COMPLETION') == '1',
    opts = {
      url = os.getenv('OLLAMA_URL'),
      model = 'qwen2.5-coder:3b',
      debounce_ms = 500,
    },
  },
  {
    'goropikari/claude.nvim',
    dependencies = {
      'folke/snacks.nvim',
      'goropikari/terminals.nvim',
    },
    opts = {
      terminals = 'terminals.nvim',
    },
  },
  {
    'goropikari/codex.nvim',
    build = 'make',
    dependencies = {
      'folke/snacks.nvim',
    },
    opts = {
      terminals = 'terminals.nvim',
    },
  },
  os.getenv('COMPANY_LLM_PLUGIN_PATH') and {
    dir = os.getenv('COMPANY_LLM_PLUGIN_PATH'),
    opts = {},
  },
}
