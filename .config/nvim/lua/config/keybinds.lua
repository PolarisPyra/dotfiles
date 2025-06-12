vim.g.mapleader = " "
vim.keymap.set("n", "<leader>cd", vim.cmd.Ex)
vim.keymap.set("n", "-", "<cmd>Oil --float<CR>", {
    desc = "Open Parent Directory in Oil"
})

