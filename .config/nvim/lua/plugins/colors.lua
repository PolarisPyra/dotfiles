local function enable_transparency()
    vim.api.nvim_set_hl(0, "Normal", {bg = "none"})
end

return { 
    {
	"scottmckendry/cyberdream.nvim",
	lazy = false, 
	priority = 1000,
	config = function() 
	    vim.cmd.colorscheme "cyberdream"
	    enable_transparency()
	end
    },
    {
	"nvim-lualine/lualine.nvim",
	dependencies = {
	    "nvim-tree/nvim-web-devicons",
	},
	opts = {
	    theme = 'cyberdream'
	},
    },
}
