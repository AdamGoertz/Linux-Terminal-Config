return {
  {
    'nvim-treesitter/nvim-treesitter',
    config = function()
      require('nvim-treesitter.configs').setup({
        ensure_installed = { "c", "lua", "vim", "vimdoc", "python", "zig", "cpp" },

        -- Install parsers synchronously (only applied to `ensure_installed`)
        sync_install = false,

        -- Automatically install missing parsers when entering buffer
        -- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
        auto_install = true,
        highlight = {
          enable = true,
        },
      })
    end
  },
  {
    "nvimtools/none-ls.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim"
    },
    config = function()
      local null_ls = require('null-ls')
      local augroup = vim.api.nvim_create_augroup("LspFormatting", {})

      local lsp_formatting = function(buffer)
        vim.lsp.buf.format({
          filter = function(client)
            -- By default, ignore any formatters provider by other LSPs
            -- (such as those managed via lspconfig or mason)
            -- Also "eslint as a formatter" doesn't work :(
            return client.name == "null-ls"
          end,
          bufnr = buffer,
        })
      end

      -- Format on save
      -- https://github.com/jose-elias-alvarez/null-ls.nvim/wiki/Avoiding-LSP-formatting-conflicts#neovim-08
      local on_attach = function(client, buffer)
        -- the Buffer will be null in buffers like nvim-tree or new unsaved files
        if (not buffer) then
          return
        end

        if client.supports_method("textDocument/formatting") then
          vim.api.nvim_clear_autocmds({ group = augroup, buffer = buffer })
          vim.api.nvim_create_autocmd("BufWritePre", {
            group = augroup,
            buffer = buffer,
            callback = function()
              lsp_formatting(buffer)
            end,
          })
        end
      end

      null_ls.setup({
        sources = {
          -- Formatting
          null_ls.builtins.formatting.black,
          null_ls.builtins.formatting.black.with({
            extra_args = {"--line-length", "80"}
          }),

          -- Code actions for staging hunks, blame, etc
          null_ls.builtins.code_actions.gitsigns,
          null_ls.builtins.completion.luasnip,

          -- Diagnostics
          null_ls.builtins.diagnostics.mypy,
        },
        on_attach = on_attach
      })
    end
  },
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
      "folke/neodev.nvim",
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
          vim.keymap.set('n', '<leader>ca', '<cmd>lua vim.lsp.buf.code_action()<cr>', opts)
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

      require("neodev").setup({
        library = { plugins = { "nvim-dap-ui" }, types = true }, })

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

          ["pylsp"] = function()
            require("lspconfig").pylsp.setup({
              -- plugins = {
              --   pycodestyle = {
              --     ["max-line-length"] = 80,
              --   },
              -- },
            })
          end,

          ["clangd"] = function()
            require("lspconfig").clangd.setup {
              capabilities = capabilities,
              cmd = {
                "clangd",
                "--offset-encoding=utf-16",
              },
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
          ['<C-k>'] = cmp.mapping.select_prev_item(cmp_select),
          ['<C-j>'] = cmp.mapping.select_next_item(cmp_select),
          ['<C-l>'] = cmp.mapping.confirm({ select = true }),
          ["<C-Space>"] = cmp.mapping.complete(),
        }),
        sources = cmp.config.sources({
          { name = 'nvim_lsp' },
          { name = 'null_ls' },
          { name = 'luasnip' },
          { name = 'neodev' },
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
  {
    'numToStr/Comment.nvim',
    opts = {},
    lazy = false,
  },
}
