return {
	'zbirenbaum/copilot.lua',
	cmd = 'Copilot',
	event = 'InsertEnter',
	config = function()
		require('copilot').setup {
			panel = {
				enabled = true,
				auto_refresh = false,
				keymap = {
					jump_prev = '[[',
					jump_next = ']]',
					accept = '<CR>',
					refresh = 'gr',
					open = '<M-CR>',
				},
				layout = {
					position = 'bottom',
					ratio = 0.4,
				},
			},

			suggestion = {
				enabled = true,
				auto_trigger = true, -- Changed to true for automatic suggestions
				hide_during_completion = true,
				debounce = 75,
				keymap = {
					accept = '<Tab>', -- Changed to Tab for accepting suggestions
					accept_word = false,
					accept_line = false,
					next = '<M-]>',
					prev = '<M-[>',
					dismiss = '<C-]>',
				},
			},
			filetypes = {
				yaml = false,
				markdown = false,
				help = false,
				gitcommit = false,
				gitrebase = false,
				hgcommit = false,
				svn = false,
				cvs = false,
				json = false,
				['.'] = false,
			},
			copilot_node_command = 'node',
			server_opts_overrides = {},
		}
	end,
}
