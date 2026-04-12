-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!

vim.env.GIT_EDITOR = 'nano'
vim.env.LANG = 'en_US.UTF-8'

vim.g.mapleader = ','
vim.g.maplocalleader = ','
vim.o.shell = 'bash'

-- -- message 系での enter 入力省略
-- -- ref: https://zenn.dev/kawarimidoll/articles/4da7458c102c1f
-- vim.o.cmdheight = 0
-- local ok, extui = pcall(require, 'vim._core.ui2')
-- if ok then
--   extui.enable({
--     enable = true, -- extuiを有効化
--     msg = {
--       pos = 'cmd', -- 'box'か'cmd'だがcmdheight=0だとどっちでも良い？（記事後述）
--       box = {
--         timeout = 5000, -- boxメッセージの表示時間 ミリ秒
--       },
--     },
--   })
-- end

-- tab の表示幅
vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4

function _G.status_filepath()
  local file = vim.api.nvim_buf_get_name(0)
  if file == '' then
    return '[No Name]'
  end

  local path = vim.fn.fnamemodify(file, ':p:~')

  if vim.fn.strdisplaywidth(path) <= 50 then
    return path
  end

  local parts = vim.split(path, '/', { plain = true })

  if #parts <= 1 then
    return path
  end

  for i = 1, #parts - 1 do
    local part = parts[i]
    if part ~= '' and part ~= '~' then
      parts[i] = vim.fn.strcharpart(part, 0, 1)
    end
  end

  return table.concat(parts, '/')
end

-- %f: relative file path
-- %m: modified flag
-- %=: separates left and right sections
-- %r: readonly flag
-- %y: file type
vim.o.statusline = "%{get(b:,'gitsigns_head','')} %{%v:lua.status_filepath()%} %m %=%r %{%v:lua.require('claude').statusline_summary()%} %y"

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'go' },
  callback = function()
    vim.bo.expandtab = false
  end,
})
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'lua' },
  callback = function()
    vim.bo.expandtab = true
    vim.bo.tabstop = 2
    vim.bo.shiftwidth = 2
  end,
})

-- Set highlight on search
vim.o.hlsearch = true

-- Make line numbers default
vim.wo.number = true

-- Enable mouse mode
vim.o.mouse = 'a'

-- Enable break indent
-- 折り返された行もインデントが適用して表示される
vim.o.breakindent = true

-- Save undo history
-- vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
-- 検索時に大文字小文字を区別しない。ただし \C を付けて検索すると区別する
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
-- git の差分がある行や breakpoint の位置などを表示する列を常に表示する
vim.wo.signcolumn = 'yes'

-- Decrease update time
-- vim.o.updatetime = 250
-- vim.o.timeoutlen = 300

-- Set completeopt to have a better completion experience
vim.o.completeopt = 'menuone,noselect'

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

-- 折りたたみの基準
vim.o.foldmethod = 'indent'
vim.o.foldlevel = 99 -- 起動時にコードの折りたたみを無効にした状態で開く
-- vim.api.nvim_command('set nofoldenable') -- 起動時にコードの折りたたみを無効にした状態で開く

vim.opt.swapfile = false

-- clipboard
vim.schedule(function()
  vim.opt.clipboard = 'unnamedplus'
end)

local function is_docker()
  local stat = vim.uv.fs_stat('/.dockerenv')
  return stat ~= nil
end

-- https://neovim.io/doc/user/provider.html#clipboard-osc52
if vim.fn.has('wsl') == 1 or is_docker() then
  vim.g.clipboard = {
    name = 'OSC 52',
    copy = {
      ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
    },
    paste = {
      -- https://github.com/neovim/neovim/discussions/28010#discussioncomment-9877494
      ['+'] = function()
        return {
          vim.fn.split(vim.fn.getreg(''), '\n'),
          vim.fn.getregtype(''),
        }
      end,
    },
  }
end

-- 'x' の削除をブラックホールレジスタに送る
vim.keymap.set('n', 'x', '"_x', { silent = true })
vim.keymap.set('n', 'X', '"_X', { silent = true })

-- terminal mode を escape で抜ける
vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]])

-- terminal mode で esc を terminal で開いているアプリに渡す
vim.keymap.set('t', '<C-q>', function()
  vim.fn.chansend(vim.b.terminal_job_id, '\x1b')
end)

-- default のコメントキーマップを無効化
vim.keymap.del({ 'n', 'v' }, 'gc')
vim.keymap.del({ 'n' }, 'gcc')

-- 削除して挿入のキーバインドを無効化
vim.keymap.set('n', 's', '<NOP>')
vim.keymap.set('n', 'S', '<NOP>')

-- command history 表示を無効化
vim.keymap.set('n', 'q:', '<NOP>')

-- Messages command
vim.keymap.set('n', '<leader>ne', '<cmd>Messages<cr>', { desc = 'Messages' })

-- Dockerfile から始まるファイルの filetype を dockerfile に設定
vim.api.nvim_create_autocmd({ 'BufRead', 'BufNewFile' }, {
  pattern = 'Dockerfile*',
  callback = function()
    vim.bo.filetype = 'dockerfile'
  end,
})
