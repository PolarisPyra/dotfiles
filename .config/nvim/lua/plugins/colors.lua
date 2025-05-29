return {
	"rose-pine/neovim",
	name = "rose-pine",
	config = function()
		require("rose-pine").setup({
			variant = "moon",
			dark_variant = "moon",
			dim_inactive_windows = false,
			extend_background_behind_borders = true,

			enable = {
				terminal = true,
				legacy_highlights = true,
			},
			styles = {
				transparency = false,
			},
		})

		vim.cmd("colorscheme rose-pine")
	end,
}
