return {
  {
    -- https://www.lazyvim.org/plugins/linting
    'mfussenegger/nvim-lint',
    event = 'VeryLazy',
    opts = {
      -- Event to trigger linters
      events = { 'BufWritePost', 'BufReadPost', 'InsertLeave' },
      linters_by_ft = {
        ['*'] = { 'gitleaks' },
        ['go'] = {
          'revive',
          'errcheck',
        },
        -- Use the "*" filetype to run linters on all filetypes.
        -- ['*'] = { 'global linter' },
        -- Use the "_" filetype to run linters on filetypes that don't have other linters configured.
        -- ['_'] = { 'fallback linter' },
        -- ["*"] = { "typos" },
      },
      -- LazyVim extension to easily override linter options
      -- or add custom linters.
      ---@type table<string,table>
      linters = {
        -- -- Example of using selene only when a selene.toml file is present
        -- selene = {
        --   -- `condition` is another LazyVim extension that allows you to
        --   -- dynamically enable/disable linters based on the context.
        --   condition = function(ctx)
        --     return vim.fs.find({ "selene.toml" }, { path = ctx.filename, upward = true })[1]
        --   end,
        -- },
        errcheck = {
          cmd = 'errcheck',
          stdin = false,
          append_fname = false,
          args = { './...' },
          cwd = find_go_module_root,
          ignore_exitcode = true,
          parser = function(output, bufnr)
            local items = {}

            if output == nil or output == '' then
              return items
            end

            local bufpath = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ':p')
            local pkg_dir = vim.fn.fnamemodify(bufpath, ':h')

            for line in output:gmatch('[^\r\n]+') do
              local file, lnum, col, message = line:match('^(.+):(%d+):(%d+):%s*(.+)$')
              if file and lnum and col and message then
                local fullpath
                if vim.startswith(file, '/') then
                  fullpath = vim.fn.fnamemodify(file, ':p')
                else
                  fullpath = vim.fn.fnamemodify(pkg_dir .. '/' .. file, ':p')
                end

                -- Removed the condition `if fullpath == bufpath then` to show diagnostics from all files
                table.insert(items, {
                  source = 'errcheck',
                  lnum = tonumber(lnum) - 1,
                  col = tonumber(col) - 1,
                  message = 'unchecked error: ' .. message,
                  severity = vim.diagnostic.severity.WARN,
                  -- Added filename to parser output to support project-wide diagnostics
                  filename = fullpath,
                })
              end
            end

            return items
          end,
        },
      },
    },
    config = function(_, opts)
      local M = {}

      -- Helper function to find the Go module root
      local function find_go_module_root()
        local current_dir = vim.fn.getcwd() -- Start from current working directory of nvim
        while current_dir and current_dir ~= '/' do
          -- Check if go.mod exists and is readable
          if vim.fn.test_file(current_dir .. '/go.mod', 'r') then
            return current_dir
          end
          -- Go up one directory. Use :h to get parent directory.
          local parent_dir = vim.fn.fnamemodify(current_dir, ':h')
          -- Avoid infinite loop if already at root and parent_dir is the same
          if parent_dir == current_dir then
            break
          end
          current_dir = parent_dir
        end
        return vim.fn.getcwd() -- Fallback to current working directory if go.mod not found
      end

      local lint = require('lint')
      for name, linter in pairs(opts.linters) do
        if type(linter) == 'table' and type(lint.linters[name]) == 'table' then
          lint.linters[name] = vim.tbl_deep_extend('force', lint.linters[name], linter)
          if type(linter.prepend_args) == 'table' then
            lint.linters[name].args = lint.linters[name].args or {}
            vim.list_extend(lint.linters[name].args, linter.prepend_args)
          end
        else
          lint.linters[name] = linter
        end
      end
      lint.linters_by_ft = opts.linters_by_ft

      function M.debounce(ms, fn)
        local timer = vim.uv.new_timer()
        return function(...)
          local argv = { ... }
          timer:start(ms, 0, function()
            timer:stop()
            vim.schedule_wrap(fn)(unpack(argv))
          end)
        end
      end

      function M.lint()
        -- Use nvim-lint's logic first:
        -- * checks if linters exist for the full filetype first
        -- * otherwise will split filetype by "." and add all those linters
        -- * this differs from conform.nvim which only uses the first filetype that has a formatter
        local names = lint._resolve_linter_by_ft(vim.bo.filetype)

        -- Create a copy of the names table to avoid modifying the original.
        names = vim.list_extend({}, names)

        -- Add fallback linters.
        if #names == 0 then
          vim.list_extend(names, lint.linters_by_ft['_'] or {})
        end

        -- Add global linters.
        vim.list_extend(names, lint.linters_by_ft['*'] or {})

        -- Filter out linters that don't exist or don't match the condition.
        local ctx = { filename = vim.api.nvim_buf_get_name(0) }
        ctx.dirname = vim.fn.fnamemodify(ctx.filename, ':h')
        names = vim.tbl_filter(function(name)
          local linter = lint.linters[name]
          if not linter then
            LazyVim.warn('Linter not found: ' .. name, { title = 'nvim-lint' })
          end
          return linter and not (type(linter) == 'table' and linter.condition and not linter.condition(ctx))
        end, names)

        -- Run linters.
        if #names > 0 then
          lint.try_lint(names)
        end
      end

      vim.api.nvim_create_autocmd(opts.events, {
        group = vim.api.nvim_create_augroup('nvim-lint', { clear = true }),
        callback = M.debounce(100, M.lint),
      })
    end,
  },
}
