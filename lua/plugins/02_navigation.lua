return {
  {
    'nvim-neo-tree/neo-tree.nvim',
    branch = 'v3.x',
    dependencies = {
      'nvim-lua/plenary.nvim',
      'nvim-tree/nvim-web-devicons',
      'MunifTanjim/nui.nvim',
    },
    keys = {
      {
        '<c-e>',
        function()
          require('neo-tree.command').execute({ toggle = true })
        end,
        desc = 'Explorer NeoTree',
      },
    },
    opts = {
      sources = { 'filesystem', 'buffers', 'git_status', 'document_symbols' },
      open_files_do_not_replace_types = { 'terminal', 'Trouble', 'trouble', 'qf', 'Outline' },
      filesystem = {
        bind_to_cwd = true,
        follow_current_file = { enabled = true },
        use_libuv_file_watcher = true,
        filtered_items = {
          hide_dotfiles = false,
          hide_gitignored = false,
        },
      },
      window = {
        position = 'left',
      },
      default_component_configs = {
        indent = {
          with_expanders = true,
          expander_collapsed = '',
          expander_expanded = '',
          expander_highlight = 'NeoTreeExpander',
        },
      },
    },
  },
  {
    'goropikari/tabflow.nvim',
    lazy = false,
    opts = {
      commands = {
        'TabflowOpenWorktree',
      },
      right_section = function()
        local line = {}
        local ok, claude = pcall(require, 'claude')
        if ok then
          table.insert(line, 'cl ' .. claude.statusline_summary())
        end
        local ok2, codex = pcall(require, 'codex')
        if ok2 then
          table.insert(line, 'ch ' .. codex.statusline_summary())
        end
        table.insert(line, os.date('%H:%M:%S'))
        return table.concat(line, ' | ')
      end,
      right_section_refresh_ms = 1000,
    },
    keys = {
      {
        '<C-A-t>',
        function()
          require('tabflow.actions').toggle_mode()
        end,
        desc = 'go to the previous tab',
      },
      {
        '<leader>bca',
        function()
          require('tabflow.actions').delete_other_buffers()
        end,
        desc = 'close all buffers except the current one',
      },
    },
  },
  {
    'stevearc/aerial.nvim',
    lazy = true,
    opts = {},
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons',
    },
    keys = {
      {
        '<leader>o',
        function()
          require('aerial').toggle()
        end,
        desc = 'code outline',
      },
    },
  },
  {
    'goropikari/window-selector.nvim',
    dev = true,
    keys = {
      {
        '<leader>sw',
        function()
          require('window-selector').select_window()
        end,
        desc = 'select window',
      },
    },
  },
}
