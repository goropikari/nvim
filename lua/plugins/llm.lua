return {
  {
    'goropikari/ollama-completion.nvim',
    event = 'InsertEnter',
    cond = os.getenv('ENABLE_OLLAMA_COMPLETION') == '1',
    opts = {
      url = os.getenv('OLLAMA_URL'),
      -- model = 'qwen2.5-coder:1.5b',
      model = 'qwen2.5-coder:3b',
      -- model = 'qwen3-coder:30b',
      debounce_ms = 500,
    },
    -- opts = {
    --   url = os.getenv('ANTHROPIC_BASE_URL'),
    --   model = 'stable-code:3b',
    --   prompt_template = '<FIM_PREFIX>%s<FIM_PREFIX>%s<FIM_MIDDLE>',
    --   options = {
    --     stop = {
    --       '<FIM_PREFIX>',
    --       '<FIM_MIDDLE>',
    --       '<FIM_SUFFIX>',
    --       '<FIM_PAD>',
    --     },
    --   },
    -- },
    -- opts = {
    --   url = os.getenv('ANTHROPIC_BASE_URL'),
    --   model = 'starcoder2:3b',
    --   prompt_template = '<fim_prefix>%s<fim_prefix>%s<fim_middle>',
    --   options = {
    --     stop = {
    --       '<fim_prefix>',
    --       '<fim_middle>',
    --       '<fim_suffix>',
    --       '<fim_pad>',
    --       '<endoftext>',
    --       '<file_sep>',
    --     },
    --   },
    -- },
    -- opts = {
    --   url = os.getenv('ANTHROPIC_BASE_URL'),
    --   model = 'codegemma:2b',
    --   options = {
    --     stop = {
    --       '<|file_separator|>',
    --     },
    --   },
    -- },
    -- opts = {
    --   url = os.getenv('ANTHROPIC_BASE_URL'),
    --   model = 'codellama:7b-code',
    --   prompt_template = '<PRE>%s<SUF>%s<MID>',
    --   options = {
    --     stop = {
    --       '<PRE>',
    --       '<SUF>',
    --       '<MID>',
    --     },
    --   },
    -- },
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
  os.getenv('COMPANY_LLM_PLUGIN_PATH') and {
    dir = os.getenv('COMPANY_LLM_PLUGIN_PATH'),
    opts = {},
  },
}
