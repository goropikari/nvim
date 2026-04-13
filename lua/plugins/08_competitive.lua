return {
  {
    'goropikari/online-judge.nvim',
    enabled = vim.fn.executable('go') == 1,
    cond = os.getenv('ENABLE_ONLINE_JUDGE') == '1',
    dev = true,
    build = 'go install github.com/goropikari/yosupo_judge_client/cmd/yosupocl@latest',
    opts = {
      oj = {
        tle = 3,
        path = (function()
          if vim.fn.executable('oj') == 1 then
            return 'oj'
          end
          local oj_venv = vim.fn.fnamemodify('~/venv/bin/oj', ':p')
          if vim.fn.executable(oj_venv) == 1 then
            return oj_venv
          end
        end)(),
      },
    },
    keys = {
      {
        '<leader>at',
        function()
          require('online-judge').test()
        end,
        desc = 'online-judge test',
      },
      {
        '<leader>ao',
        function()
          local line = vim.api.nvim_buf_get_lines(0, 0, 1, false)[1]
          local url = string.match(line, 'https?://[%w-_/.?%+=&%%#]+')
          if url then
            vim.system({ 'explorer.exe', url }, { text = true }, function(out)
              if out.code ~= 0 then
                vim.schedule(function()
                  vim.notify(out.stderr, vim.log.levels.ERROR)
                end)
              end
            end)
          else
            vim.notify('url not found in the first line')
          end
        end,
        desc = 'open problem url',
      },
      {
        '<leader>ai',
        function()
          if vim.fn.expand('%:p'):match('yosupo') then
            require('online-judge.service.yosupo').insert_problem_url()
          elseif vim.fn.expand('%:p'):match('aoj') then
            require('online-judge.service.aoj').insert_problem_url()
          elseif vim.fn.expand('%:p'):match('atcoder') then
            require('online-judge.service.atcoder').insert_problem_url()
          else
            require('online-judge.service.null').insert_problem_url()
          end

          vim.api.nvim_buf_set_lines(0, 1, 1, false, { string.format(vim.bo.commentstring, vim.fn.strftime('%c')) })
        end,
        desc = 'insert atcoder url',
      },
      {
        '<leader>acd',
        function()
          require('online-judge').create_test_dir()
        end,
        desc = 'create test directory for non supported site',
      },
      {
        '<leader>agi',
        function()
          local suffix = vim.fn.expand('%:p:t:r')
          local filename_with_ext = string.format('geni_%s.py', suffix)
          vim.cmd('split')
          vim.cmd('e ' .. filename_with_ext)

          local buf = vim.fn.bufnr(filename_with_ext)
          vim.keymap.set('n', '<F5>', function()
            vim.system({
              'oj',
              'g/i',
              '-d',
              'test_' .. suffix,
              'python3 ' .. filename_with_ext,
            }, { text = true }, function(out)
              vim.schedule(function()
                if out.code ~= 0 then
                  vim.notify(out.stderr, vim.log.levels.ERROR)
                else
                  vim.notify(out.stdout)
                end
              end)
            end)
          end, { buffer = buf, noremap = true, silent = true })
        end,
        desc = 'generate random input testcase',
      },
      {
        '<leader>ago',
        function()
          local suffix = vim.fn.expand('%:p:t:r')
          local filename = string.format('geno_%s', suffix)
          local filename_with_ext = filename .. '.cpp'
          vim.cmd('split')
          vim.cmd('e ' .. filename_with_ext)

          local buf = vim.fn.bufnr(filename_with_ext)
          vim.keymap.set('n', '<F5>', function()
            vim.system({
              'make',
              vim.fn.fnamemodify(filename_with_ext, ':t:r'),
            }, { text = true }, function(out)
              vim.schedule(function()
                if out.code ~= 0 then
                  vim.notify(out.stderr, vim.log.levels.ERROR)
                else
                  vim.notify(out.stdout)
                  vim.system({
                    'oj',
                    'g/o',
                    '-d',
                    'test_' .. suffix,
                    '-c',
                    './' .. filename,
                  }, { text = true }, function(out2)
                    vim.schedule(function()
                      if out2.code ~= 0 then
                        vim.notify(out2.stderr, vim.log.levels.ERROR)
                      else
                        vim.notify(out2.stdout)
                      end
                    end)
                  end)
                end
              end)
            end)
          end, { buffer = buf, noremap = true, silent = true })
        end,
        desc = 'generate random output testcase',
      },
    },
  },
}
