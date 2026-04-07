local M = {}

-- 選択した行を取得する
---@return table<string>
function M.get_visual_lines(opts)
  if vim.fn.mode() == 'n' then -- command から使う用
    local res = vim.fn.getline(opts.line1, opts.line2)
    if type(res) == 'string' then
      res = { res }
    end
    return res
  else -- <leader> key を使った keymap 用
    local lines = vim.fn.getregion(vim.fn.getpos('v'), vim.fn.getpos('.'), { type = vim.fn.mode() })
    -- https://github.com/neovim/neovim/discussions/26092
    vim.cmd([[ execute "normal! \<ESC>" ]])
    return lines
  end
end

function M.show_visual_lines(opts)
  print(vim.fn.join(M.get_visual_lines(opts) or {}, '\n'))
end

-- vim.api.nvim_create_user_command('ShowVisualLines', function(opts)
--   show_visual_lines(opts)
-- end, {
--   range = 0, -- これを入れないと No range allowed というエラーが出る
-- })

function M.dig(tb, keys)
  local ret = nil
  for _, v in ipairs(keys) do
    ret = tb[v]
    if ret == nil then
      return ''
    end
    tb = tb[v]
  end
  return ret
end

return M
