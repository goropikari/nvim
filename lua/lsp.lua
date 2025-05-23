vim.env.PATH = vim.env.PATH .. ':' .. vim.fn.stdpath('data') .. '/mason/bin'

vim.lsp.enable({
  'clangd',
  'gopls',
  'lua_ls',
  'pylsp',
  'ruby_lsp',
  'typos_lsp',
})
