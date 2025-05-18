vim.env.PATH = vim.env.PATH .. ':' .. vim.fn.stdpath('data') .. '/mason/bin'

vim.lsp.enable({
  'clangd',
  'gopls',
  'lua_ls',
  'pyright',
  'ruby_lsp',
  'typos_lsp',
})
