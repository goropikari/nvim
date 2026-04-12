return {
  {
    'salkin-mada/openscad.nvim',
    enabled = vim.fn.executable('openscad') == 1,
    ft = { 'openscad' },
    dependencies = {
      'L3MON4D3/LuaSnip',
    },
    config = function()
      require('openscad')
      -- load snippets, note requires
      vim.g.openscad_load_snippets = true
    end,
  },
  {
    'goropikari/jsonc.vim',
    ft = { 'json', 'jsonc' },
    dev = true,
  },
  {
    'MeanderingProgrammer/render-markdown.nvim', -- Make sure to set this up properly if you have lazy=true
    ft = { 'markdown' },
    opts = {},
  },
  {
    'aklt/plantuml-syntax',
    ft = { 'plantuml' },
  },
  {
    'goropikari/plantuml.nvim',
    dependencies = {
      'goropikari/LibDeflate.nvim',
    },
    dev = true,
    ft = { 'plantuml' },
    cmd = { 'PlantumlPreview', 'PlantumlExport', 'PlantumlStartDocker' },
    opts = {},
  },
  {
    'goropikari/openfga.nvim',
    ft = { 'fga', 'openfga' },
    dev = true,
    opts = {},
  },
  {
    'goropikari/default-new-file.nvim',
    dev = true,
    -- ft = { 'plantuml', 'go', 'cpp' },
    opts = {
      pattern = { '*.plantuml', '*.go', '*.cpp', '*.py' },
    },
  },
}
