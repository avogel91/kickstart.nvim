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
    opts = {
      -- add any options here
      custom_highlights = function(C)
        return {
          WinSeparator = { fg = C.base },
        }
      end,
    },
    init = function()
      vim.cmd.colorscheme 'catppuccin-macchiato'

      vim.cmd.hi 'TreesitterContextLineNumberBottom gui=underline guisp=Grey'
      vim.cmd.hi 'TreesitterContext guibg=none guisp=Grey'
      vim.cmd.hi 'TreesitterContextLineNumber guibg=none'
      vim.cmd.hi 'Statusline guibg=none guifg=none'
      vim.cmd.hi 'StatuslineInactive guibg=none guifg=none'
      vim.cmd.hi 'NvimTreeNormal guibg=none'
      vim.cmd.hi 'NvimTreeRootFolder guibg=none'
      vim.cmd.hi 'TelescopeBorder guibg=none guisp=green'

      local colors = require('catppuccin.palettes').get_palette()
      local TelescopeColor = {
        TelescopeMatching = { fg = colors.flamingo },
        TelescopeSelection = { fg = colors.text, bg = colors.surface0, bold = true },

        TelescopePromptPrefix = { bg = colors.mantle },
        TelescopePromptNormal = { bg = colors.mantle },
        TelescopeResultsNormal = { bg = colors.mantle },
        TelescopePreviewNormal = { bg = colors.mantle },
        TelescopePromptBorder = { bg = colors.mantle, fg = colors.mantle },
        TelescopeResultsBorder = { bg = colors.mantle, fg = colors.mantle },
        TelescopePreviewBorder = { bg = colors.mantle, fg = colors.mantle },
        TelescopePromptTitle = { bg = colors.pink, fg = colors.mantle },
        TelescopeResultsTitle = { fg = colors.mantle },
        TelescopePreviewTitle = { bg = colors.green, fg = colors.mantle },
      }

      for hl, col in pairs(TelescopeColor) do
        vim.api.nvim_set_hl(0, hl, col)
      end
    end,
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
      local custom_auto = require 'lualine.themes.auto'
      custom_auto.normal.c.bg = '#24273a'
      custom_auto.inactive.a.bg = '#24273a'
      custom_auto.inactive.b.bg = '#24273a'
      custom_auto.inactive.c.bg = '#24273a'
      require('lualine').setup {
        options = {
          theme = custom_auto,
          component_separators = '',
          icons_enabled = true,
          section_separators = { left = '', right = '' },
          disabled_filetypes = {
            statusline = {
              'dashboard',
              'aerial',
              'dapui_.',
              'neo%-tree',
              'NvimTree',
              'dapui_watches',
              'dapui_stacks',
              'dapui_scopes',
              'dapui_breakpoints',
              'dapui_variables',
              'dapui_repl',
            },
          },
        },
        sections = {
          lualine_a = { { 'mode', separator = { left = '' }, right_padding = 2 } },
          lualine_b = { { 'filename', path = 1 }, 'branch' },
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
        view = {
          width = 50,
          side = 'right',
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
      local dapui = require 'dapui'

      dap.adapters.php = {
        type = 'executable',
        command = 'node',
        args = { os.getenv 'HOME' .. '/repositories/vscode-php-debug/out/phpDebug.js' },
      }

      dap.configurations.php = {
        -- to run php right from the editor
        {
          name = 'run current script',
          type = 'php',
          request = 'launch',
          port = 9003,
          cwd = '${fileDirname}',
          program = '${file}',
          runtimeExecutable = 'php',
          runtimeArgs = { '-dxdebug.start_with_request=yes' },
          env = {
            XDEBUG_CONFIG = 'client_port=${port}',
            XDEBUG_MODE = 'debug, develop',
          },
          breakpoints = {
            exception = {
              Notice = false,
              Warning = false,
              Error = false,
              Exception = false,
              ['*'] = false,
            },
          },
        },
        -- to listen to any php call
        {
          name = 'listen for Xdebug local',
          type = 'php',
          request = 'launch',
          port = 9003,
        },
        -- to listen to php call in docker container
        {
          name = 'docker',
          type = 'php',
          request = 'launch',
          port = 9003,

          -- this is where your file is in the container
          pathMappings = {
            ['/var/www/xentral'] = '${workspaceFolder}',
          },
        },
      }
      require('dap-go').setup()
      dap.listeners.after.event_initialized['dapui_config'] = function()
        dapui.open()
      end

      -- dap.listeners.before.event_terminated['dapui_config'] = function()
      --   dapui.close()
      -- end
      --
      -- dap.listeners.before.event_exited['dapui_config'] = function()
      --   dapui.close()
      -- end
      dapui.setup()

      -- ui.toggle()
      -- Keymap for DAP
      vim.keymap.set('n', '<leader>b', dap.toggle_breakpoint)
      vim.keymap.set('n', '<leader>gb', dap.run_to_cursor)
      vim.keymap.set('n', '<leader>dc', dap.continue)
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
  {
    'epwalsh/obsidian.nvim',
    version = '*', -- recommended, use latest release instead of latest commit
    lazy = true,
    ft = 'markdown',
    -- Replace the above line with this if you only want to load obsidian.nvim for markdown files in your vault:
    -- event = {
    --   -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
    --   -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/*.md"
    --   -- refer to `:h file-pattern` for more examples
    --   "BufReadPre path/to/my-vault/*.md",
    --   "BufNewFile path/to/my-vault/*.md",
    -- },
    dependencies = {
      -- Required.
      'nvim-lua/plenary.nvim',

      -- see below for full list of optional dependencies 👇
    },
    opts = {
      workspaces = {
        {
          name = 'personal',
          path = '~/Documents/Obsidian/Personal/',
        },
      },
      daily_notes = {
        -- Optional, if you keep daily notes in a separate directory.
        folder = 'daily-notes',
        -- Optional, if you want to change the date format for the ID of daily notes.
        date_format = '%Y-%m-%d',
        -- Optional, if you want to change the date format of the default alias of daily notes.
        alias_format = '%B %-d, %Y',
        -- Optional, default tags to add to each new daily note created.
        default_tags = { 'daily-notes' },
        -- Optional, if you want to automatically insert a template from your template directory like 'daily.md'
        template = nil,
      },
      completion = {
        -- Set to false to disable completion.
        nvim_cmp = true,
        -- Trigger completion at 2 chars.
        min_chars = 2,
      },

      -- Optional, configure key mappings. These are the defaults. If you don't want to set any keymappings this
      -- way then set 'mappings = {}'.
      mappings = {
        -- Overrides the 'gf' mapping to work on markdown/wiki links within your vault.
        ['gf'] = {
          action = function()
            return require('obsidian').util.gf_passthrough()
          end,
          opts = { noremap = false, expr = true, buffer = true },
        },
        -- Toggle check-boxes.
        ['<leader>ch'] = {
          action = function()
            return require('obsidian').util.toggle_checkbox()
          end,
          opts = { buffer = true },
        },
        -- Smart action depending on context, either follow link or toggle checkbox.
        ['<cr>'] = {
          action = function()
            return require('obsidian').util.smart_action()
          end,
          opts = { buffer = true, expr = true },
        },
      },
      -- see below for full list of options 👇
    },
  },
}
