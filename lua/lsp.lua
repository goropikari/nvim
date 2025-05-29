vim.env.PATH = vim.env.PATH .. ':' .. vim.fn.stdpath('data') .. '/mason/bin'

vim.lsp.enable({
  'bashls',
  'buf_ls',
  'clangd',
  'dprint',
  'gopls',
  'lua_ls',
  'pylsp',
  'ruby_lsp',
  'typos_lsp',
})
