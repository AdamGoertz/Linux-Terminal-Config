local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath, })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
    -- Colors
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        terminal_colors = true,
        config = function()
            require("tokyonight").setup({
                on_colors = function(colors)
                    colors.border = "#565f89"
                end,
                on_highlights = function(highlights, colors)
                    highlights.LineNr.fg = colors.dark5
                    highlights.Comment.fg = colors.dark5
                end
            })
            vim.cmd([[colorscheme tokyonight]])
        end,
        styles = {
            comments = { italic = false },
            keywords = { italic = false },
            -- Background styles. Can be "dark", "transparent" or "normal"
            sidebars = "dark", -- style for sidebars, see below
            floats = "dark",   -- style for floating windows
        },
    },
    -- UI
    {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        config = function()
            local function harpoon_component()
                local harpoon = require("harpoon")
                local current_mark = "—"
                local current_buf = vim.api.nvim_get_current_buf()

                local total_marks = harpoon:list():length()
                for i = 1, total_marks do
                    local item = harpoon:list():get(i)
                    local mark_bufnr = vim.fn.bufnr(item.value)
                    if mark_bufnr ~= -1 and mark_bufnr == current_buf then
                        current_mark = tostring(i)
                        break
                    end
                end

                return string.format("󱡅 %s/%d", current_mark, total_marks)
            end

            require("lualine").setup({
                options = {
                    theme = "tokyonight",
                    globalstatus = true,
                    component_separators = { left = "", right = "" },
                    section_separators = { left = "█", right = "█" },
                },
                sections = {
                    lualine_b = {
                        harpoon_component,
                        "diff",
                        "diagnostics",
                    },
                    lualine_c = {
                        { "filename", path = 1 },
                    },
                    lualine_x = {
                        "filetype",
                    },
                },
            })
        end,
    },

    -- tmux integration
    {
        'alexghergh/nvim-tmux-navigation',
        config = function()
            local nvim_tmux_nav = require('nvim-tmux-navigation')

            nvim_tmux_nav.setup {
                disable_when_zoomed = true -- defaults to false
            }

            vim.keymap.set('n', "<C-h>", nvim_tmux_nav.NvimTmuxNavigateLeft)
            vim.keymap.set('n', "<C-j>", nvim_tmux_nav.NvimTmuxNavigateDown)
            vim.keymap.set('n', "<C-k>", nvim_tmux_nav.NvimTmuxNavigateUp)
            vim.keymap.set('n', "<C-l>", nvim_tmux_nav.NvimTmuxNavigateRight)
            vim.keymap.set('n', "<C-\\>", nvim_tmux_nav.NvimTmuxNavigateLastActive)
            -- vim.keymap.set('n', "<C-Space>", nvim_tmux_nav.NvimTmuxNavigateNext)
        end,
    },

    -- Git
    {
        "tpope/vim-fugitive",
        config = function()
            vim.keymap.set("n", "<leader>git", vim.cmd.Git)
        end,
    },
    {
        "lewis6991/gitsigns.nvim",
        config = function()
            require('gitsigns').setup {
                signs                        = {
                    add          = { text = '│' },
                    change       = { text = '│' },
                    delete       = { text = '_' },
                    topdelete    = { text = '‾' },
                    changedelete = { text = '~' },
                    untracked    = { text = '┆' },
                },
                signcolumn                   = true,  -- Toggle with `:Gitsigns toggle_signs`
                numhl                        = false, -- Toggle with `:Gitsigns toggle_numhl`
                linehl                       = false, -- Toggle with `:Gitsigns toggle_linehl`
                word_diff                    = false, -- Toggle with `:Gitsigns toggle_word_diff`
                watch_gitdir                 = {
                    follow_files = true
                },
                auto_attach                  = true,
                attach_to_untracked          = false,
                current_line_blame           = true, -- Toggle with `:Gitsigns toggle_current_line_blame`
                current_line_blame_opts      = {
                    virt_text = true,
                    virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
                    delay = 1000,
                    ignore_whitespace = false,
                    virt_text_priority = 100,
                },
                current_line_blame_formatter = '<author>, <author_time:%Y-%m-%d> - <summary>',
                sign_priority                = 6,
                update_debounce              = 100,
                status_formatter             = nil,   -- Use default
                max_file_length              = 40000, -- Disable if file is longer than this (in lines)
                preview_config               = {
                    -- Options passed to nvim_open_win
                    border = 'single',
                    style = 'minimal',
                    relative = 'cursor',
                    row = 0,
                    col = 1
                },
                yadm                         = {
                    enable = false
                },
            }
        end
    },

    -- File search
    {
        "nvim-lua/plenary.nvim",
        name = "plenary"
    },
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.5",
        dependencies = {
            "nvim-lua/plenary.nvim"
        },
        config = function()
            require('telescope').setup({
                pickers = {
                    find_files = {
                        hidden = true,
                    },
                },
            })

            local builtin = require('telescope.builtin')
            vim.keymap.set('n', '<leader>ff', builtin.find_files, {})
            vim.keymap.set('n', '<leader>fw', function()
                local word = vim.fn.expand("<cword>")
                builtin.grep_string({ search = word })
            end)
            vim.keymap.set('n', '<leader>fW', function()
                local word = vim.fn.expand("<cWORD>")
                builtin.grep_string({ search = word })
            end)
            vim.keymap.set('n', '<leader>fg', function()
                builtin.live_grep({})
            end)
            vim.keymap.set('n', '<leader>fh', builtin.help_tags, {})
        end
    },
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        config = function()
            local harpoon = require("harpoon")

            harpoon:setup()

            vim.keymap.set("n", "<leader>ha", function() harpoon:list():append() end)
            vim.keymap.set("n", "<leader>ho", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

            for i = 1, 4 do
                vim.keymap.set("n", string.format("<leader>%d", i), function() harpoon:list():select(i) end)
            end
        end
        ,
    },
    {
        'stevearc/oil.nvim',
        opts = {},
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("oil").setup({
                columns = {
                    "icon",
                    "size",
                },
                keymaps = {
                    ["g?"] = "actions.show_help",
                    ["<CR>"] = "actions.select",
                    ["<C-v>"] = "actions.select_vsplit",
                    ["<C-s>"] = "actions.select_split",
                    ["<C-t>"] = "actions.select_tab",
                    ["<BS>"] = "actions.parent",
                    ["_"] = "actions.open_cwd",
                    ["gs"] = "actions.change_sort",
                    ["g."] = "actions.toggle_hidden",
                    ["g\\"] = "actions.toggle_trash",
                },
                delete_to_trash = false,
                constrain_cursor = "editable",
            })
            vim.keymap.set("n", "<leader>fe", "<cmd>Oil --float<CR>")
        end
    },


    -- Diagnostic
    {
        "folke/trouble.nvim",
        config = function()
            require("trouble").setup({
                icons = false,
            })

            vim.keymap.set("n", "<leader>tt", function()
                require("trouble").toggle()
            end)

            vim.keymap.set("n", "[t", function()
                require("trouble").next({ skip_groups = true, jump = true });
            end)

            vim.keymap.set("n", "]t", function()
                require("trouble").previous({ skip_groups = true, jump = true });
            end)

            vim.keymap.set("n", "<leader>tq", function() require("trouble").toggle("quickfix") end)
        end
    },

    -- Undotree
    {
        "mbbill/undotree",
        config = function()
            vim.keymap.set("n", "<leader>u", vim.cmd.UndotreeToggle)
        end
    },

    -- Editor
    {
        'numToStr/Comment.nvim',
        opts = {},
        lazy = false,
    },

    -- LSP
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "hrsh7th/nvim-cmp",
            "j-hui/fidget.nvim",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
        },

        config = function()
            vim.api.nvim_create_autocmd('LspAttach', {
                desc = 'LSP actions',
                callback = function(event)
                    local opts = { buffer = event.buf }

                    -- these will be buffer-local keybindings
                    -- because they only work if you have an active language server
                    vim.keymap.set('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', opts)
                    vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', opts)
                    vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', opts)
                    vim.keymap.set('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', opts)
                    vim.keymap.set('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', opts)
                    vim.keymap.set('i', '<C-o>', '<cmd>lua vim.lsp.buf.signature_help()<cr>', opts)
                    vim.keymap.set('n', '<leader>rn', '<cmd>lua vim.lsp.buf.rename()<cr>', opts)
                end
            })

            local cmp = require('cmp')
            local cmp_lsp = require("cmp_nvim_lsp")
            local capabilities = vim.tbl_deep_extend(
                "force",
                {},
                vim.lsp.protocol.make_client_capabilities(),
                cmp_lsp.default_capabilities())

            require("fidget").setup({})
            require("mason").setup()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls",
                    "clangd",
                    "zls",
                    "pylsp",
                },
                handlers = {
                    function(server_name) -- default handler (optional)
                        require("lspconfig")[server_name].setup {
                            capabilities = capabilities
                        }
                    end,

                    ["lua_ls"] = function()
                        local lspconfig = require("lspconfig")
                        lspconfig.lua_ls.setup {
                            capabilities = capabilities,
                            settings = {
                                Lua = {
                                    diagnostics = {
                                        globals = { "vim", "it", "describe", "before_each", "after_each" },
                                    }
                                }
                            }
                        }
                    end,
                }
            })

            local cmp_select = { behavior = cmp.SelectBehavior.Select }

            cmp.setup({
                snippet = {
                    expand = function(args)
                        require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
                    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
                    ['<CR>'] = cmp.mapping.confirm({ select = true }),
                    ["<C-Space>"] = cmp.mapping.complete(),
                }),
                sources = cmp.config.sources({
                    { name = 'nvim_lsp' },
                    { name = 'luasnip' },
                }, {
                    { name = 'buffer' },
                })
            })


            vim.diagnostic.config({
                -- update_in_insert = true,
                float = {
                    focusable = false,
                    style = "minimal",
                    border = "rounded",
                    source = "always",
                    header = "",
                    prefix = "",
                },
            })
        end
    },
})
