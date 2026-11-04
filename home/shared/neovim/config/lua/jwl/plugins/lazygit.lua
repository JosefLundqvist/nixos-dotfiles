return {
    {
        "kdheepak/lazygit.nvim",
        cmd = {
            "LazyzGit",
            "LazyzGitConfig",
            "LazyzGitCurrentFile",
            "LazyzGitFilter",
            "LazyzGitFilterCurrentFile",
        },
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        keys = {
            { "<leader>vc", "<cmd>LazyGit<cr>", desc = "Open LazyGit" },
        },
    }
}
