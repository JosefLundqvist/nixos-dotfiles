return {
    {
        "echasnovski/mini.nvim",
        config = function()
            -- require('mini.statusline').setup { use_icons = false }
            require('mini.pairs').setup()
            require('mini.comment').setup()
            require('mini.trailspace').setup()
        end,
    }
}
