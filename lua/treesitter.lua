local ensure_installed = { 'bash', 'c', 'cpp', 'go', 'json', 'lua', 'python', 'ruby', 'vim', 'vimdoc' }

require('nvim-treesitter').install(ensure_installed)

vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('vim-treesitter-start', {}),
  callback = function(ctx)
    pcall(vim.treesitter.start)
  end,
})
