local api = vim.api

api.nvim_create_user_command('LiveServer', function(opts)
  local dir = vim.fn.expand('%:h')
  if dir == '' then
    dir = vim.fn.getcwd()
  end
  local _cmd = {
    'python3',
    '-m',
    'http.server',
    '--directory',
    dir,
  }
  vim.list_extend(_cmd, vim.split(opts.args, ' '))

  local cmd = {}
  for _, v in ipairs(_cmd) do
    if v ~= '' then
      table.insert(cmd, v)
    end
  end
  vim.notify(vim.fn.join(cmd, ' '))

  vim.system(cmd, {}, function(obj)
    if obj.code ~= 0 then
      vim.notify(obj.stderr, vim.log.levels.WARN)
      return
    end
  end)
end, { nargs = '*' })

-- https://github.com/LazyVim/LazyVim/blob/v12.38.2/lua/lazyvim/config/autocmds.lua
local function augroup(name)
  return api.nvim_create_augroup(name, { clear = true })
end

-- Check if we need to reload the file when it changed
api.nvim_create_autocmd({ 'FocusGained', 'TermClose', 'TermLeave' }, {
  group = augroup('checktime'),
  callback = function()
    if vim.o.buftype ~= 'nofile' then
      vim.cmd('checktime')
    end
  end,
})

-- api.nvim_create_autocmd({ 'BufEnter' }, {
--   pattern = { 'term://*' },
--   callback = function(event)
--     if vim.bo.filetype == 'toggleterm' then
--       vim.cmd('startinsert')
--     end
--   end,
-- })

-- resize splits if window got resized
api.nvim_create_autocmd({ 'VimResized' }, {
  group = augroup('resize_splits'),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd('tabdo wincmd =')
    vim.cmd('tabnext ' .. current_tab)
  end,
})

-- Auto create dir when saving a file, in case some intermediate directory does not exist
api.nvim_create_autocmd({ 'BufWritePre' }, {
  group = augroup('auto_create_dir'),
  callback = function(event)
    if event.match:match('^%w%w+:[\\/][\\/]') then
      return
    end
    local file = vim.uv.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ':p:h'), 'p')
  end,
})

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = api.nvim_create_augroup('YankHighlight', { clear = true })
api.nvim_create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank()
  end,
  group = highlight_group,
  pattern = '*',
})

if vim.uv.os_uname().sysname == 'Linux' and vim.fn.executable('fcitx5-remote') then
  -- ime off = 1
  -- mozc = 2
  vim.g.last_ime_state = 0

  -- Insertモードを抜けるときに現在のIME状態を記録
  vim.api.nvim_create_autocmd('InsertLeave', {
    pattern = '*',
    callback = function()
      local result = tonumber(vim.fn.system('fcitx5-remote'))
      vim.g.last_ime_state = result or 1
      vim.fn.system('fcitx5-remote -c')
    end,
  })

  vim.api.nvim_create_autocmd('InsertEnter', {
    pattern = '*',
    callback = function()
      if vim.g.last_ime_state == 2 then
        vim.fn.system('fcitx5-remote -o') -- IME をオンに戻す
      end
    end,
  })
end
