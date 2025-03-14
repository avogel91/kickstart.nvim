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
      local nvimTreeFocusOrToggle = function()
        local nvimTree = require 'nvim-tree.api'
        local currentBuf = vim.api.nvim_get_current_buf()
        local currentBufFt = vim.api.nvim_get_option_value('filetype', { buf = currentBuf })
        if currentBufFt == 'NvimTree' then
          nvimTree.tree.toggle()
        else
          nvimTree.tree.focus()
        end
      end
      require('nvim-tree').setup {
        vim.keymap.set('n', '<leader>e', nvimTreeFocusOrToggle, { desc = 'Toggle Nvim Tree' }),
        vim.keymap.set('n', '<leader>tc', '<cmd>NvimTreeCollapse<CR>', { desc = 'Nvim [T]ree [C]ollapse' }),
        update_focused_file = {
          enable = true,
        },
        filters = {
          dotfiles = false,
        },
        filesystem_watchers = {
          enable = true,
          debounce_delay = 50,
          ignore_dirs = { 'node_modules', '**/node_modules', 'vendor', '**/vendor' },
        },
        view = {
          width = 60,
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
      function insert_xdebug()
        local pos = vim.api.nvim_win_get_cursor(0)[2]
        local line = vim.api.nvim_get_current_line()
        local nline = line:sub(0, pos) .. 'xdebug_break();' .. line:sub(pos + 1)
        vim.api.nvim_set_current_line(nline)
      end

      vim.keymap.set('n', '<leader>dx', '<cmd>lua insert_xdebug()<cr>')
    end,
  },
  {
    'github/copilot.vim',
    event = 'InsertEnter',
  },
  {
    'yetone/avante.nvim',
    event = 'VeryLazy',
    lazy = false,
    version = '*', -- Set this to "*" to always pull the latest release version, or set it to false to update to the latest code changes.
    opts = {
      -- add any opts here
      -- for example
      provider = 'copilot',
      copilot = {
        model = 'claude-3.7-sonnet', -- your desired model (or use gpt-4o, etc.)
        timeout = 30000, -- timeout in milliseconds
        temperature = 0, -- adjust if needed
        max_tokens = 4096,
        -- reasoning_effort = "high" -- only supported for reasoning models (o1, etc.)
      },
    },
    -- auto_suggestion_provider = 'copilot',
    -- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
    build = 'make',
    -- build = "powershell -ExecutionPolicy Bypass -File Build.ps1 -BuildFromSource false" -- for windows
    behaviour = {
      auto_suggestions = true, -- Experimental stage
      auto_set_highlight_group = true,
      auto_set_keymaps = true,
      auto_apply_diff_after_generation = false,
      support_paste_from_clipboard = false,
      minimize_diff = true, -- Whether to remove unchanged lines when applying a code block
      enable_token_counting = true, -- Whether to enable token counting. Default to true.
      enable_cursor_planning_mode = false, -- Whether to enable Cursor Planning Mode. Default to false.
    },
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'stevearc/dressing.nvim',
      'nvim-lua/plenary.nvim',
      'MunifTanjim/nui.nvim',
      --- The below dependencies are optional,
      'echasnovski/mini.pick', -- for file_selector provider mini.pick
      'nvim-telescope/telescope.nvim', -- for file_selector provider telescope
      'hrsh7th/nvim-cmp', -- autocompletion for avante commands and mentions
      'ibhagwan/fzf-lua', -- for file_selector provider fzf
      'nvim-tree/nvim-web-devicons', -- or echasnovski/mini.icons
      'zbirenbaum/copilot.lua', -- for providers='copilot'
      {
        -- support for image pasting
        'HakonHarnes/img-clip.nvim',
        event = 'VeryLazy',
        opts = {
          -- recommended settings
          default = {
            embed_image_as_base64 = false,
            prompt_for_file_name = false,
            drag_and_drop = {
              insert_mode = true,
            },
            -- required for Windows users
            use_absolute_path = true,
          },
        },
      },
      {
        -- Make sure to set this up properly if you have lazy=true
        'MeanderingProgrammer/render-markdown.nvim',
        opts = {
          file_types = { 'markdown', 'Avante' },
        },
        ft = { 'markdown', 'Avante' },
      },
    },
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
  {
    'EmranMR/tree-sitter-blade',
    -- load the plugin at startup
    event = 'VeryLazy',
    config = function()
      require('nvim-treesitter.configs').setup {
        ensure_installed = 'blade',
        highlight = {
          enable = true,
        },
      }
    end,
  },
  {
    'windwp/nvim-ts-autotag',
    event = 'VeryLazy',
    config = function()
      require('nvim-ts-autotag').setup {
        opts = {
          -- Defaults
          enable_close = true, -- Auto close tags
          enable_rename = true, -- Auto rename pairs of tags
          enable_close_on_slash = false, -- Auto close on trailing </
        },
      }
    end,
  },
  {
    'stevearc/aerial.nvim',
    opts = {},
    -- Optional dependencies
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      require('aerial').setup {
        -- optionally use on_attach to set keymaps when aerial has attached to a buffer
        on_attach = function(bufnr)
          -- Jump forwards/backwards with '{' and '}'
          vim.keymap.set('n', '{', '<cmd>AerialPrev<CR>', { buffer = bufnr })
          vim.keymap.set('n', '}', '<cmd>AerialNext<CR>', { buffer = bufnr })
        end,
      }
      vim.keymap.set('n', '<leader>o', '<cmd>AerialToggle!<CR>')
    end,
  },
}
