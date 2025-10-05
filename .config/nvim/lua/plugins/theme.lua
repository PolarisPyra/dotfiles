return {
	"drewtempelmeyer/palenight.vim",
	lazy = false, -- Load immediately
	priority = 1000, -- Load before other plugins
	config = function()
		-- Optional: Configure palenight settings before loading
		vim.g.palenight_terminal_italics = 1

		-- Set the colorscheme
		vim.cmd([[colorscheme palenight]])
	end,
}
