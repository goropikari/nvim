return {
  {
    'mason-org/mason.nvim',
    version = '*',
    cmd = { 'Mason' },
    opts = {},
  },
  {
    'WhoIsSethDaniel/mason-tool-installer.nvim',
    cmd = { 'MasonToolsInstall', 'MasonToolsUpdate' },
    opts = {
      ensure_installed = {
        {
          'bash-language-server', -- lsp
          condition = function()
            return vim.fn.executable('npm') == 1
          end,
        },
        'buf',
        'clangd', -- lsp
        'codelldb',
        {
          'delve',
          condition = function()
            return vim.fn.executable('go') == 1
          end,
        },
        {
          'gofumpt',
          condition = function()
            return vim.fn.executable('go') == 1
          end,
        },
        {
          'goimports',
          condition = function()
            return vim.fn.executable('go') == 1
          end,
        },
        {
          'gopls', -- lsp
          condition = function()
            return vim.fn.executable('go') == 1
          end,
        },
        {
          'python-lsp-server', -- lsp
          condition = function()
            return vim.fn.executable('python3') == 1
          end,
        },
        {
          'ruby-lsp', -- lsp
          condition = function()
            return vim.fn.executable('ruby') == 1
          end,
        },
        'lua-language-server', -- lsp
        'stylua', -- Used to format Lua code
        {
          'markdownlint-cli2',
          condition = function()
            return vim.fn.executable('npm') == 1
          end,
        },
        'cbfmt',
        'dprint',
        'typos-lsp', -- lsp
      },
    },
  },
  {
    'hrsh7th/cmp-nvim-lsp',
  },
  {
    -- LSP Configuration & Plugins
    'neovim/nvim-lspconfig',
    version = '*',
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          -- NOTE: Remember that Lua is a real programming language, and as such it is possible
          -- to define small helper and utility functions so you don't have to repeat yourself.
          --
          -- In this case, we create a function that lets us more easily define mappings specific
          -- for LSP related items. It sets the mode, buffer and description for us each time.
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          -- Jump to the definition of the word under your cursor.
          --  This is where a variable was first declared, or where a function is defined, etc.
          --  To jump back, press <C-t>.
          map('gd', require('telescope.builtin').lsp_definitions, 'Goto Definition')

          -- Find references for the word under your cursor.
          map('gr', require('telescope.builtin').lsp_references, 'Goto References')

          -- Jump to the implementation of the word under your cursor.
          --  Useful when your language has ways of declaring types without an actual implementation.
          map('gI', require('telescope.builtin').lsp_implementations, 'Goto Implementation')

          -- Jump to the type of the word under your cursor.
          --  Useful when you're not sure what type a variable is and you want to see
          --  the definition of its *type*, not where it was *defined*.
          map('<leader>lD', require('telescope.builtin').lsp_type_definitions, 'Type Definition')

          -- Fuzzy find all the symbols in your current document.
          --  Symbols are things like variables, functions, types, etc.
          map('<leader>lds', require('telescope.builtin').lsp_document_symbols, 'Document Symbols')

          -- Fuzzy find all the symbols in your current workspace.
          --  Similar to document symbols, except searches over your entire project.
          map('<leader>lws', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Workspace Symbols')

          -- Rename the variable under your cursor.
          --  Most Language Servers support renaming across files, etc.
          map('<leader>lrn', vim.lsp.buf.rename, 'Rename')
          map('<F2>', vim.lsp.buf.rename, 'Rename')

          -- Execute a code action, usually your cursor needs to be on top of an error
          -- or a suggestion from your LSP for this to activate.
          -- map('<leader>lca', vim.lsp.buf.code_action, 'Code Action', { 'n', 'x' })
          map('<leader>lca', function()
            vim.lsp.buf.code_action({ context = { diagnostics = {}, only = { 'quickfix', 'refactor', 'source' } }, apply = true })
          end, 'Code Action', { 'n', 'x' })

          -- WARN: This is not Goto Definition, this is Goto Declaration.
          --  For example, in C this would take you to the header.
          map('gD', vim.lsp.buf.declaration, 'Goto Declaration')

          map('<leader>lK', vim.lsp.buf.hover, 'Hover Documentation')
          map('<leader>ldh', vim.lsp.buf.hover, 'Hover Documentation')
          map('<leader>lf', function(_)
            vim.lsp.buf.format()
          end, 'Format')
          map('<leader>lgD', vim.lsp.buf.declaration, 'Goto Declaration')
          map('<leader>lgI', require('telescope.builtin').lsp_implementations, 'Goto Implementation')
          map('<leader>lgd', require('telescope.builtin').lsp_definitions, 'Goto Definition')
          map('<leader>lgr', require('telescope.builtin').lsp_references, 'Goto References')
          map('<leader>lk', vim.lsp.buf.signature_help, 'Signature Documentation')

          -- The following two autocommands are used to highlight references of the
          -- word under your cursor when your cursor rests there for a little while.
          --    See `:help CursorHold` for information about when this is executed
          --
          -- When you move your cursor, the highlights will be cleared (the second autocommand).
          local client = vim.lsp.get_client_by_id(event.data.client_id)
          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
            local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
            vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.document_highlight,
            })

            vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
              buffer = event.buf,
              group = highlight_augroup,
              callback = vim.lsp.buf.clear_references,
            })

            vim.api.nvim_create_autocmd('LspDetach', {
              group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
              callback = function(event2)
                vim.lsp.buf.clear_references()
                vim.api.nvim_clear_autocmds({ group = 'kickstart-lsp-highlight', buffer = event2.buf })
              end,
            })
          end

          -- The following code creates a keymap to toggle inlay hints in your
          -- code, if the language server you are using supports them
          --
          -- This may be unwanted, since they displace some of your code
          if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
            map('<leader>lth', function()
              vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
            end, 'Toggle Inlay Hints')
          end
          vim.diagnostic.config({
            virtual_lines = {
              format = function(diagnostic)
                return string.format('%s: %s: %s', diagnostic.source, diagnostic.code, diagnostic.message)
              end,
            },
          })
        end,
      })
    end,
  },
}
