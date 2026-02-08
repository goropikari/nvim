vim.env.PATH = vim.env.PATH .. ':' .. vim.fn.stdpath('data') .. '/mason/bin'

vim.lsp.enable({
  'bashls',
  'buf_ls',
  'clangd',
  'docker_language_server',
  'dprint',
  'gopls',
  'lua_ls',
  'pylsp',
  'ruby_lsp',
  'typos_lsp',
  'yamlls',
})
