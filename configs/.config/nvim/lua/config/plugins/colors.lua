return {
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
}
