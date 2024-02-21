return {
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

    -- Other
    {
        "iamcco/markdown-preview.nvim",
        cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
        ft = { "markdown" },
        build = function() vim.fn["mkdp#util#install"]() end,
    },
}
