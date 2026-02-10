return {
    "greggh/claude-code.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim", -- Required for git operations
    },
    opts = {
        window = {
            position = "float",
            float = {
                width = "75%",
                height = "75%",
            }
        },
        keymaps = {
            toggle = {
                normal = "<leader>c",
                terminal = "<esc><esc>",
                variants = {
                    resume = "<leader>C",
                    verbose = false
                }
            }
        }
    },
}
