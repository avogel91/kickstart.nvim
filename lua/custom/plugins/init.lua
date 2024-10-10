-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'numToStr/Comment.nvim',
    opts = {
      -- add any options here
      toggler = {
        ---Line-comment toggle keymap
        line = 'gcc',
        ---Block-comment toggle keymap
        block = 'gbc',
      },
    },
  },
  {
    'catppuccin/nvim',
    name = 'catppuccin',
    priority = 1000,
    init = function()
      vim.cmd.colorscheme 'catppuccin-macchiato'
    end,
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      require('lualine').setup {
        options = {
          component_separators = '',
          section_separators = { left = '', right = '' },
          disabled_filetypes = {
            statusline = {
              'dashboard',
              'aerial',
              'dapui_.',
              'neo%-tree',
              'NvimTree',
            },
          },
        },
        sections = {
          lualine_a = { { 'mode', separator = { left = '' }, right_padding = 2 } },
          lualine_b = { { 'filename', path = 2 }, 'branch' },
          lualine_c = {
            '%=', --[[ add your center compoentnts here in place of this comment ]]
          },
          lualine_x = {},
          lualine_y = { 'filetype', 'progress' },
          lualine_z = {
            { 'location', separator = { right = '' }, left_padding = 2 },
          },
        },
        inactive_sections = {
          lualine_a = { 'filename' },
          lualine_b = {},
          lualine_c = {},
          lualine_x = {},
          lualine_y = {},
          lualine_z = { 'location' },
        },
        tabline = {},
        extensions = {},
      }
    end,
  },
  {
    'nvim-tree/nvim-tree.lua',
    version = '*',
    lazy = false,
    dependencies = {
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      require('nvim-tree').setup {
        vim.keymap.set('n', '<leader>o', '<cmd>NvimTreeOpen<CR>', { desc = 'Nvim Tree [O]pen' }),
        vim.keymap.set('n', '<leader>e', '<cmd>NvimTreeToggle<CR>', { desc = 'Toggle Nvim Tree' }),
        vim.keymap.set('n', '<leader>tc', '<cmd>NvimTreeCollapse<CR>', { desc = 'Nvim [T]ree [C]ollapse' }),
        update_focused_file = {
          enable = true,
        },
        filters = {
          dotfiles = false,
        },
        git = {
          enable = true,
          ignore = false,
        },
      }
    end,
  },
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      'leoluz/nvim-dap-go',
      'rcarriga/nvim-dap-ui',
      'theHamsta/nvim-dap-virtual-text',
      'nvim-neotest/nvim-nio',
      'williamboman/mason.nvim',
    },
    config = function()
      local dap = require 'dap'

      require('dapui').setup()
      require('dap-go').setup()

      -- ui.toggle()
      -- Keymap for DAP
      vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint)
      vim.keymap.set('n', '<leader>gb', dap.run_to_cursor)
      vim.keymap.set('n', '<leader>ds', '<cmd>lua dap.continue()<CR>')
      vim.keymap.set('n', '<leader>du', "<cmd>lua require'dapui'.toggle()<cr>", { desc = '[D]ebug [U]I' })
      -- Icon customisation
      vim.fn.sign_define('DapBreakpoint', { text = '◎', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
      vim.fn.sign_define('DapStopped', { text = '⌲', texthl = 'DapBreakpoint', linehl = 'DapBreakpoint', numhl = 'DapBreakpoint' })
    end,
  },
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    config = function()
      require('copilot').setup {
        panel = {
          enabled = true,
          auto_refresh = false,
          keymap = {
            jump_prev = '[[',
            jump_next = ']]',
            accept = '<CR>',
            refresh = 'gr',
            open = '<M-CR>',
          },
          layout = {
            position = 'bottom', -- | top | left | right
            ratio = 0.4,
          },
        },
        suggestion = {
          enabled = true,
          auto_trigger = true,
          hide_during_completion = true,
          debounce = 75,
          keymap = {
            accept = '<Tab>',
            accept_word = false,
            accept_line = false,
            next = '<M-]>',
            prev = '<M-[>',
            dismiss = '<C-]>',
          },
        },
        filetypes = {
          yaml = false,
          markdown = false,
          help = false,
          gitcommit = false,
          gitrebase = false,
          hgcommit = false,
          svn = false,
          cvs = false,
          ['.'] = false,
        },
        copilot_node_command = 'node', -- Node.js version must be > 18.x
        server_opts_overrides = {},
      }
    end,
    vim.keymap.set('n', '<leader>cp', '<cmd>lua require("copilot.suggestion").toggle_auto_trigger()<CR>', { desc = 'Toggle Copilot' }),
  },
  {
    'f-person/git-blame.nvim',
    -- load the plugin at startup
    event = 'VeryLazy',
    -- Because of the keys part, you will be lazy loading this plugin.
    -- The plugin wil only load once one of the keys is used.
    -- If you want to load the plugin at startup, add something like event = "VeryLazy",
    -- or lazy = false. One of both options will work.
    -- opts = {
    --     -- your configuration comes here
    --     -- for example
    --     enabled = true,  -- if you want to enable the plugin
    --     message_template = " <summary> • <date> • <author> • <<sha>>", -- template for the blame message, check the Message template section for more options
    --     date_format = "%m-%d-%Y %H:%M:%S", -- template for the date, check Date format section for more options
    --     virtual_text_column = 1,  -- virtual text start column, check Start virtual text at column section for more options
    -- },
    config = function()
      -- your configuration comes here
      -- for example
      require('gitblame').setup {
        enabled = true, -- if you want to enable the plugin
        message_template = ' <summary> • <date> • <author> • <<sha>>', -- template for the blame message, check the Message template section for more options
        date_format = '%m-%d-%Y %H:%M:%S', -- template for the date, check Date format section for more options
        virtual_text_column = 1, -- virtual text start column, check Start virtual text at column section for more options
      }
      vim.keymap.set('n', '<leader>gb', '<cmd>GitBlameToggle<CR>', { desc = 'Toggle Git Blame' })
    end,
  },
  {
    'nvim-treesitter/nvim-treesitter-context',
    -- load the plugin at startup
    event = 'VeryLazy',
    -- Because of the keys part, you will be lazy loading this plugin.
    -- The plugin wil only load once one of the keys is used.
    -- If you want to load the plugin at startup, add something like event = "VeryLazy",
    -- or lazy = false. One of both options will work.
    -- opts = {
    --     -- your configuration comes here
    --     -- for example
    --     enabled = true,  -- if you want to enable the plugin
    --     message_template = " <summary> • <date> • <author> • <<sha>>", -- template for the blame message, check the Message template section for more options
    --     date_format = "%m-%d-%Y %H:%M:%S", -- template for the date, check Date format section for more options
    --     virtual_text_column = 1,  -- virtual text start column, check Start virtual text at column section for more options
    -- },
    config = function()
      -- your configuration comes here
      -- for example
      require('treesitter-context').setup {
        enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
        max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
        min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
        line_numbers = true,
        multiline_threshold = 20, -- Maximum number of lines to show for a single context
        trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
        mode = 'cursor', -- Line used to calculate context. Choices: 'cursor', 'topline'
        -- Separator between context and content. Should be a single character string, like '-'.
        -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
        separator = nil,
        zindex = 20, -- The Z-index of the context window
        on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
      }
    end,
  },
  {
    'tpope/vim-fugitive',
  },
}
