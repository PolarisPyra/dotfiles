return {
    "goolord/alpha-nvim",
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    config = function()
        local alpha = require('alpha')
        local dashboard = require("alpha.themes.dashboard")
        
        dashboard.section.header.val = {
            [[  ^  ^  ^   ^☆ ★ ☆ ___I_☆ ★ ☆ ^  ^   ^  ^  ^   ^  ^ ]],
            [[ /|\/|\/|\ /|\ ★☆ /\-_--\ ☆ ★/|\/|\ /|\/|\/|\ /|\/|\ ]],
            [[ /|\/|\/|\ /|\ ★ /  \_-__\☆ ★/|\/|\ /|\/|\/|\ /|\/|\ ]],
            [[ /|\/|\/|\ /|\ 󰻀 |[]| [] | 󰻀 /|\/|\ /|\/|\/|\ /|\/|\ ]],
        }

        dashboard.section.buttons.val = {
            dashboard.button("n", "  New file", ":ene <BAR> startinsert <CR>"),
            dashboard.button("f", "󰍉  Find file", ":Telescope find_files<CR>"),
            dashboard.button("b", "  Browse cwd", ":Neotree toggle<CR>"),
            dashboard.button("c", "  Config", ":e /home/polaris/dotfiles/.config/nvim/<CR>"),
            dashboard.button("m", "󰥻  Mappings", ":e /home/polaris/dotfiles/.config/nvim/lua/config/keymaps.lua<CR>"),
            dashboard.button("p", "  Cozynet", ":e /home/polaris/projects/cozynet<CR>"),

            dashboard.button("q", "󰅙  Quit", ":q!<CR>"),
        }

        dashboard.section.footer.val = function()
            return vim.g.startup_time_ms or "[[  ]]"
        end

        dashboard.section.buttons.opts.hl = "Keyword"
        dashboard.opts.opts.noautocmd = true
        alpha.setup(dashboard.opts)
    end,
}