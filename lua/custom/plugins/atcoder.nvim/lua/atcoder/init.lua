local M = {}

---@class Config
---@field out_dirpath string

---@type Config
local default_config = {
  out_dirpath = '/tmp/atcoder/',
}

---@type Config
---@diagnostic disable-next-line
local config = {}

vim.keymap.set('n', '<leader>WW', function()
  vim.cmd('messages clear')
  if vim.api.nvim_get_option_value('modified', { filetype = 'cpp' }) then
    vim.cmd('write')
  end
  vim.cmd('%y"+') -- ファイル全体を clipboard にコピー
  vim.system({
    'make',
    'test',
    'INPUT=' .. vim.fn.expand('%:a'),
    'OUTPUT=' .. config.out_dirpath .. vim.fn.expand('%:t:r'),
  }, {}, function(out)
    vim.print(out.stdout)
    vim.schedule(function()
      vim.cmd('messages')
    end)
  end)
end, { noremap = true, silent = true, desc = '競プロ: Save file and copy' })

function M.setup(opts)
  config = vim.tbl_deep_extend('force', default_config, opts or {})
  vim.fn.mkdir(config.out_dirpath, 'p')
end

return M
