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
          'bash-language-server',
          condition = function()
            return vim.fn.executable('npm') == 1
          end,
        },
        {
          'buf',
        },
        {
          'clangd',
          condition = function()
            return vim.fn.executable('g++') == 1
          end,
        },
        {
          'codelldb',
          condition = function()
            return vim.fn.executable('g++') == 1
          end,
        },
        {
          'delve',
          condition = function()
            return vim.fn.executable('go') == 1
          end,
        },
        {
          'gotestsum',
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
          'gopls',
          condition = function()
            return vim.fn.executable('go') == 1
          end,
        },
        {
          'revive',
          condition = function()
            return vim.fn.executable('go') == 1
          end,
        },
        {
          'python-lsp-server',
          condition = function()
            return vim.fn.executable('python3-venv') == 1 or vim.fn.executable('python-venv') == 1
          end,
        },
        {
          'ruby-lsp',
          condition = function()
            return vim.fn.executable('ruby') == 1
          end,
        },
        {
          'lua-language-server',
        },
        {
          'sleek',
          condition = function()
            return vim.fn.executable('cargo') == 1
          end,
        },
        {
          'stylua',
        },
        {
          'markdownlint-cli2',
          condition = function()
            return vim.fn.executable('npm') == 1
          end,
        },
        {
          'docker-language-server',
          condition = function()
            return vim.fn.executable('docker') == 1
          end,
        },
        {
          'cbfmt',
        },
        {
          'dprint',
        },
        {
          'typos-lsp',
        },
        {
          'yaml-language-server',
        },
        {
          'checkmake',
        },
        {
          'shellcheck',
        },
      },
    },
  },
  {
    'hrsh7th/cmp-nvim-lsp',
  },
  {
    'neovim/nvim-lspconfig',
    version = '*',
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
        callback = function(event)
          local map = function(keys, func, desc, mode)
            mode = mode or 'n'
            vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
          end

          map('gd', require('snacks').picker.lsp_definitions, 'Goto Definition')
          map('gr', require('snacks').picker.lsp_references, 'Goto References')
          map('gI', require('snacks').picker.lsp_implementations, 'Goto Implementation')
          map('<leader>lrn', vim.lsp.buf.rename, 'Rename')
          map('<F2>', vim.lsp.buf.rename, 'Rename')
          map('<leader>lca', function()
            vim.lsp.buf.code_action({ context = { diagnostics = {}, only = { 'quickfix', 'refactor', 'source' } }, apply = true })
          end, 'Code Action', { 'n', 'x' })
          map('gD', vim.lsp.buf.declaration, 'Goto Declaration')
          map('<leader>lK', vim.lsp.buf.hover, 'Hover Documentation')
          map('<leader>ldh', vim.lsp.buf.hover, 'Hover Documentation')
          map('<leader>lf', function(_)
            vim.lsp.buf.format()
          end, 'Format')
          map('<leader>lgD', vim.lsp.buf.declaration, 'Goto Declaration')
          map('<leader>lgI', require('snacks').picker.lsp_implementations, 'Goto Implementation')
          map('<leader>lgd', require('snacks').picker.lsp_definitions, 'Goto Definition')
          map('<leader>lgr', require('snacks').picker.lsp_references, 'Goto References')
          map('<leader>lk', vim.lsp.buf.signature_help, 'Signature Documentation')

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
  {
    'j-hui/fidget.nvim',
    version = '*',
    opts = {},
  },
}
