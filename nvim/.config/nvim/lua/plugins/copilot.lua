return {
	'zbirenbaum/copilot.lua',
	cmd = 'Copilot',
	event = 'InsertEnter',
	config = function()
		require('copilot').setup {
			suggestion = {
				enabled = true,
				auto_trigger = true,
				keymap = {
					accept = '<Tab>',
					accept_word = false,
					accept_line = false,
					next = '<M-]>',
					prev = '<M-[>',
					dismiss = '<C-]>',
				},
			},
			panel = { enabled = false },
		}
	end,
}
