-- [[ Setting options ]]
-- See `:help vim.o`
-- NOTE: You can change these options as you wish!

vim.g.mapleader = ','
vim.g.maplocalleader = ','
vim.o.shell = 'bash'
vim.o.exrc = true -- current directory の .nvim.lua を読み込む

-- tab の表示幅
vim.o.expandtab = true
vim.o.tabstop = 4
vim.o.shiftwidth = 4

-- vim.o.statusline = '%f %m %=%r%{%v:lua.require("nvim-web-devicons").get_icon_by_filetype(&filetype)%} %y bufnr=%n'
-- %f: relative file path
-- %m: modified flag
-- %=: separates left and right sections
-- %r: readonly flag
-- %y: file type
-- %n: buffer number
-- %P: percentage through the file
vim.o.statusline = '%f %m %=%r %y bufnr=%n %P'

vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'go' },
  callback = function()
    vim.opt.expandtab = false
  end,
})
vim.api.nvim_create_autocmd('FileType', {
  pattern = { 'lua' },
  callback = function()
    vim.o.expandtab = true
    vim.o.tabstop = 2
    vim.o.shiftwidth = 2
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

-- https://neovim.io/doc/user/provider.html#clipboard-osc52
if vim.fn.has('wsl') == 1 or os.getenv('HOSTNAME') ~= nil then
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

-- default のコメントキーマップを無効化
vim.keymap.del({ 'n', 'v' }, 'gc')
vim.keymap.del({ 'n' }, 'gcc')

-- 削除して挿入のキーバインドを無効化
vim.keymap.set('n', 's', '<NOP>')

-- command history 表示を無効化
vim.keymap.set('n', 'q:', '<NOP>')
