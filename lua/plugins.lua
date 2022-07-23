local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
local compile_path = install_path .. "/plugin/packer_compiled.lua"
local packer_bootstrap = nil

if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim',
    install_path })
end

return require('packer').startup({
  function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    -- Needed to load first
    use { 'lewis6991/impatient.nvim' }
    use { 'nathom/filetype.nvim' }
    use { 'nvim-lua/plenary.nvim' }
    --use { 'kyazdani42/nvim-web-devicons' }
    use { 'goolord/alpha-nvim', config = "require('plugins.alpha')" }
    
    -- transparente
    use 'xiyaowong/nvim-transparent'

    --Hop
    use {
  'phaazon/hop.nvim',
  branch = 'v2', -- optional but strongly recommended
  config = function()
    -- you can configure Hop the way you like here; see :h hop-config
    require'hop'.setup { keys = 'etovxqpdygfblzhckisuran' }
  end
}

    --syntax-tree-surfer
    use "ziontee113/syntax-tree-surfer"

    --NeoTree
    use {
  "nvim-neo-tree/neo-tree.nvim",
    branch = "v2.x",
    requires = { 
      "nvim-lua/plenary.nvim",
      "kyazdani42/nvim-web-devicons", -- not strictly required, but recommended
      "MunifTanjim/nui.nvim",
      {
        -- only needed if you want to use the commands with "_with_window_picker" suffix
        's1n7ax/nvim-window-picker',
        tag = "v1.*",
        config = function()
          require'window-picker'.setup({
            autoselect_one = true,
            include_current = false,
            filter_rules = {
              -- filter using buffer options
              bo = {
                -- if the file type is one of following, the window will be ignored
                filetype = { 'neo-tree', "neo-tree-popup", "notify", "quickfix" },

                -- if the buffer type is one of following, the window will be ignored
                buftype = { 'terminal' },
              },
            },
            other_win_hl_color = '#e35e4f',
          })
        end,
      }
    },
    config = function ()
      -- Unless you are still migrating, remove the deprecated commands from v1.x
      vim.cmd([[ let g:neo_tree_remove_legacy_commands = 1 ]])

      -- If you want icons for diagnostic errors, you'll need to define them somewhere:
      vim.fn.sign_define("DiagnosticSignError",
        {text = " ", texthl = "DiagnosticSignError"})
      vim.fn.sign_define("DiagnosticSignWarn",
        {text = " ", texthl = "DiagnosticSignWarn"})
      vim.fn.sign_define("DiagnosticSignInfo",
        {text = " ", texthl = "DiagnosticSignInfo"})
      vim.fn.sign_define("DiagnosticSignHint",
        {text = "", texthl = "DiagnosticSignHint"})
      -- NOTE: this is changed from v1.x, which used the old style of highlight groups
      -- in the form "LspDiagnosticsSignWarning"

      require("neo-tree").setup({
        close_if_last_window = false, -- Close Neo-tree if it is the last window left in the tab
        popup_border_style = "rounded",
        enable_git_status = true,
        enable_diagnostics = true,
        sort_case_insensitive = false, -- used when sorting files and directories in the tree
        sort_function = nil , -- use a custom function for sorting files and directories in the tree 
        -- sort_function = function (a,b)
        --       if a.type == b.type then
        --           return a.path > b.path
        --       else
        --           return a.type > b.type
        --       end
        --   end , -- this sorts files and directories descendantly
        default_component_configs = {
          container = {
            enable_character_fade = true
          },
          indent = {
            indent_size = 2,
            padding = 1, -- extra padding on left hand side
            -- indent guides
            with_markers = true,
            indent_marker = "│",
            last_indent_marker = "└",
            highlight = "NeoTreeIndentMarker",
            -- expander config, needed for nesting files
            with_expanders = nil, -- if nil and file nesting is enabled, will enable expanders
            expander_collapsed = "",
            expander_expanded = "",
            expander_highlight = "NeoTreeExpander",
          },
          icon = {
            folder_closed = "",
            folder_open = "",
            folder_empty = "ﰊ",
            -- The next two settings are only a fallback, if you use nvim-web-devicons and configure default icons there
            -- then these will never be used.
            default = "*",
            highlight = "NeoTreeFileIcon"
          },
          modified = {
            symbol = "[+]",
            highlight = "NeoTreeModified",
          },
          name = {
            trailing_slash = false,
            use_git_status_colors = true,
            highlight = "NeoTreeFileName",
          },
          git_status = {
            symbols = {
              -- Change type
              added     = "", -- or "✚", but this is redundant info if you use git_status_colors on the name
              modified  = "", -- or "", but this is redundant info if you use git_status_colors on the name
              deleted   = "✖",-- this can only be used in the git_status source
              renamed   = "",-- this can only be used in the git_status source
              -- Status type
              untracked = "",
              ignored   = "",
              unstaged  = "",
              staged    = "",
              conflict  = "",
            }
          },
        },
        window = {
          position = "left",
          width = 40,
          mapping_options = {
            noremap = true,
            nowait = true,
          },
          mappings = {
            ["<space>"] = { 
                "toggle_node", 
                nowait = false, -- disable `nowait` if you have existing combos starting with this char that you want to use 
            },
            ["<2-LeftMouse>"] = "open",
            ["<cr>"] = "open",
            ["S"] = "open_split",
            ["s"] = "open_vsplit",
            -- ["S"] = "split_with_window_picker",
            -- ["s"] = "vsplit_with_window_picker",
            ["t"] = "open_tabnew",
            ["w"] = "open_with_window_picker",
            ["C"] = "close_node",
            ["z"] = "close_all_nodes",
            --["Z"] = "expand_all_nodes",
            ["a"] = { 
              "add",
              -- some commands may take optional config options, see `:h neo-tree-mappings` for details
              config = {
                show_path = "none" -- "none", "relative", "absolute"
              }
            },
            ["A"] = "add_directory", -- also accepts the optional config.show_path option like "add".
            ["d"] = "delete",
            ["r"] = "rename",
            ["y"] = "copy_to_clipboard",
            ["x"] = "cut_to_clipboard",
            ["p"] = "paste_from_clipboard",
            ["c"] = "copy", -- takes text input for destination, also accepts the optional config.show_path option like "add":
            -- ["c"] = {
            --  "copy",
            --  config = {
            --    show_path = "none" -- "none", "relative", "absolute"
            --  }
            --}
            ["m"] = "move", -- takes text input for destination, also accepts the optional config.show_path option like "add".
            ["q"] = "close_window",
            ["R"] = "refresh",
            ["?"] = "show_help",
          }
        },
        nesting_rules = {},
        filesystem = {
          filtered_items = {
            visible = false, -- when true, they will just be displayed differently than normal items
            hide_dotfiles = true,
            hide_gitignored = true,
            hide_hidden = true, -- only works on Windows for hidden files/directories
            hide_by_name = {
              --"node_modules"
            },
            hide_by_pattern = { -- uses glob style patterns
              --"*.meta"
            },
            never_show = { -- remains hidden even if visible is toggled to true
              --".DS_Store",
              --"thumbs.db"
            },
          },
          follow_current_file = false, -- This will find and focus the file in the active buffer every
                                       -- time the current file is changed while the tree is open.
          group_empty_dirs = false, -- when true, empty folders will be grouped together
          hijack_netrw_behavior = "open_default", -- netrw disabled, opening a directory opens neo-tree
                                                  -- in whatever position is specified in window.position
                                -- "open_current",  -- netrw disabled, opening a directory opens within the
                                                  -- window like netrw would, regardless of window.position
                                -- "disabled",    -- netrw left alone, neo-tree does not handle opening dirs
          use_libuv_file_watcher = false, -- This will use the OS level file watchers to detect changes
                                          -- instead of relying on nvim autocmd events.
          window = {
            mappings = {
              ["<bs>"] = "navigate_up",
              ["."] = "set_root",
              ["H"] = "toggle_hidden",
              ["/"] = "fuzzy_finder",
              ["D"] = "fuzzy_finder_directory",
              ["f"] = "filter_on_submit",
              ["<c-x>"] = "clear_filter",
              ["[g"] = "prev_git_modified",
              ["]g"] = "next_git_modified",
            }
          }
        },
        buffers = {
          follow_current_file = true, -- This will find and focus the file in the active buffer every
                                       -- time the current file is changed while the tree is open.
          group_empty_dirs = true, -- when true, empty folders will be grouped together
          show_unloaded = true,
          window = {
            mappings = {
              ["bd"] = "buffer_delete",
              ["<bs>"] = "navigate_up",
              ["."] = "set_root",
            }
          },
        },
        git_status = {
          window = {
            position = "float",
            mappings = {
              ["A"]  = "git_add_all",
              ["gu"] = "git_unstage_file",
              ["ga"] = "git_add_file",
              ["gr"] = "git_revert_file",
              ["gc"] = "git_commit",
              ["gp"] = "git_push",
              ["gg"] = "git_commit_and_push",
            }
          }
        }
      })

      vim.cmd([[nnoremap \ :Neotree reveal<cr>]])
    end
}

    -- jaq-nvim ejecutar el código de cualquier idioma con un solo comando.
    use {'is0n/jaq-nvim'}

    -- nvim_context_vt Muestra texto virtual del contexto actual después de funciones, métodos, sentencias, etc.
    use 'haringsrob/nvim_context_vt'

    -- conexion a bases de datos
    use({
       "kristijanhusak/vim-dadbod-ui",
            requires = {
    		"tpope/vim-dadbod",
    		"kristijanhusak/vim-dadbod-completion",
    	"tpope/vim-dotenv",
    		},
   })
   -- para inc-rename
    use {
  "smjonas/inc-rename.nvim",
  config = function()
    require("inc_rename").setup()
  end,
}

    -- Hoja de trucos de Nvim
    use {"Djancyp/cheat-sheet"}

    -- cder.nvim direcciones
    -- use 'zane-/cder.nvim'

    -- Themes
    use { 'folke/tokyonight.nvim' }

    -- Treesitter
    use { 'nvim-treesitter/nvim-treesitter', config = "require('plugins.treesitter')" }
    use { 'nvim-treesitter/nvim-treesitter-textobjects', after = { 'nvim-treesitter' } }
    use { 'RRethy/nvim-treesitter-textsubjects', after = { 'nvim-treesitter' } }
    use { 'm-demare/hlargs.nvim', config = function() require('hlargs').setup() end }

    -- Navigating (Telescope/Tree/Refactor)
    use { 'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }
    use { 'nvim-telescope/telescope.nvim',
      config = "require('plugins.telescope')",
      requires = {
        { 'nvim-lua/popup.nvim' },
        { 'nvim-lua/plenary.nvim' },
        { 'nvim-telescope/telescope-fzf-native.nvim' }
      }
    }
    use { 'cljoly/telescope-repo.nvim' }
    use { 'kevinhwang91/nvim-bqf', ft = 'qf' }
    use { 'nvim-pack/nvim-spectre' }
    --use { 'kyazdani42/nvim-tree.lua', config = "require('plugins.tree')" }

    -- LSP Base
    use { 'williamboman/nvim-lsp-installer' }
    use { 'neovim/nvim-lspconfig' }

    -- LSP Cmp
    use { 'hrsh7th/nvim-cmp', event = 'InsertEnter', config = "require('plugins.cmp')" }
    use { 'hrsh7th/cmp-nvim-lua', after = 'nvim-cmp' }
    use { 'hrsh7th/cmp-nvim-lsp', after = 'cmp-nvim-lua' }
    use { 'hrsh7th/cmp-buffer', after = 'cmp-nvim-lsp' }
    use { 'hrsh7th/cmp-path', after = 'cmp-buffer' }
    use { 'hrsh7th/cmp-cmdline', after = 'cmp-path' }
    use { 'hrsh7th/cmp-calc', after = 'cmp-cmdline' }
    use { 'tzachar/cmp-tabnine', run = './install.sh', requires = 'hrsh7th/nvim-cmp', after = 'cmp-calc' }
    use { 'David-Kunz/cmp-npm', after = 'cmp-tabnine', requires = 'nvim-lua/plenary.nvim',
      config = "require('plugins.cmp-npm')" }
    use { 'saadparwaiz1/cmp_luasnip', after = 'cmp-npm' }

    -- LSP Addons
    use { 'stevearc/dressing.nvim', requires = 'MunifTanjim/nui.nvim', config = "require('plugins.dressing')" }
    use { 'onsails/lspkind-nvim' }
    use { 'folke/lsp-trouble.nvim', config = "require('plugins.trouble')" }
    use { 'nvim-lua/popup.nvim' }
    use { 'ChristianChiarulli/nvim-gps', branch = 'text_hl', config = "require('plugins.gps')", after = 'nvim-treesitter' }
    use { 'jose-elias-alvarez/typescript.nvim' }

    -- General
    use { 'AndrewRadev/switch.vim' }
    use { 'AndrewRadev/splitjoin.vim' }
    use { 'numToStr/Comment.nvim', config = "require('plugins.comment')" }
    use { 'LudoPinelli/comment-box.nvim' }
    use { 'akinsho/nvim-toggleterm.lua', branch = 'main', config = "require('plugins.toggleterm')" }
    use { 'tpope/vim-repeat' }
    use { 'tpope/vim-speeddating' }
    use { 'dhruvasagar/vim-table-mode' }
    use { 'mg979/vim-visual-multi' }
    use { 'junegunn/vim-easy-align' }
    use { 'JoosepAlviste/nvim-ts-context-commentstring', after = 'nvim-treesitter' }
    use { 'nacro90/numb.nvim', config = "require('plugins.numb')" }
    use { 'folke/todo-comments.nvim', config = "require('plugins.todo-comments')" }
    use { 'folke/zen-mode.nvim', config = "require('plugins.zen')", disable = not EcoVim.plugins.zen.enabled }
    use { 'folke/twilight.nvim', config = function() require("twilight").setup {} end,
      disable = not EcoVim.plugins.zen.enabled }
    --use { 'ggandor/lightspeed.nvim' }
    use { 'folke/which-key.nvim', config = "require('plugins.which-key')", event = "BufWinEnter" }
    use { 'ecosse3/galaxyline.nvim', after = 'nvim-gps', config = "require('plugins.galaxyline')", event = "BufWinEnter" }
    use { 'romgrk/barbar.nvim', branch = 'feat/wipeout-cmds', requires = { 'kyazdani42/nvim-web-devicons' },
      config = "require('plugins.barbar')" }
    use { 'antoinemadec/FixCursorHold.nvim' } -- Needed while issue https://github.com/neovim/neovim/issues/12587 is still open
    use { 'rcarriga/nvim-notify' }
    use { 'vuki656/package-info.nvim', event = "BufEnter package.json", config = "require('plugins.package-info')" }
    use { 'iamcco/markdown-preview.nvim', run = "cd app && npm install",
      setup = function() vim.g.mkdp_filetypes = { "markdown" } end, ft = { "markdown" } }
    use { 'declancm/cinnamon.nvim', config = "require('plugins.cinnamon')" }
    use { 'airblade/vim-rooter', setup = function() vim.g.rooter_patterns = EcoVim.plugins.rooter.patterns end }
    use { 'Shatur/neovim-session-manager', config = "require('plugins.session-manager')" }
    use { 'kylechui/nvim-surround', config = function() require("nvim-surround").setup({}) end }

    -- Snippets & Language & Syntax
    use { 'windwp/nvim-autopairs', after = { 'nvim-treesitter', 'nvim-cmp' }, config = "require('plugins.autopairs')" }
    use { 'p00f/nvim-ts-rainbow', after = { 'nvim-treesitter' } }
    use { 'lukas-reineke/indent-blankline.nvim', config = "require('plugins.indent')" }
    use { 'NvChad/nvim-colorizer.lua', config = "require('plugins.colorizer')" }
    use { 'L3MON4D3/LuaSnip', requires = { 'rafamadriz/friendly-snippets' }, after = 'cmp_luasnip' }

    -- Git
    use { 'lewis6991/gitsigns.nvim',
      requires = { 'nvim-lua/plenary.nvim' },
      config = "require('plugins.git.signs')",
      event = "BufRead"
    }
    use { 'sindrets/diffview.nvim', config = "require('plugins.git.diffview')" }
    use { 'akinsho/git-conflict.nvim', config = "require('plugins.git.conflict')" }
    use { 'ThePrimeagen/git-worktree.nvim', config = "require('plugins.git.worktree')" }
    use { 'kdheepak/lazygit.nvim' }

    -- Testing
    use {
      "rcarriga/neotest",
      requires = {
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        "antoinemadec/FixCursorHold.nvim",
        "haydenmeade/neotest-jest"
      },
      config = "require('plugins.neotest')"
    }

    if packer_bootstrap then
      require('packer').sync()
    end
  end,
  config = {
    compile_path = compile_path,
    disable_commands = true,
    max_jobs = 50,
    display = {
      open_fn = function()
        return require('packer.util').float({ border = 'rounded' })
      end
    }
  }
})
