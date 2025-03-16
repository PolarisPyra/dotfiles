return {
  'nvimtools/none-ls.nvim',
  dependencies = {
    'nvimtools/none-ls-extras.nvim',
    'jayp0521/mason-null-ls.nvim', -- ensure dependencies are installed
  },
  config = function()
    local null_ls = require 'null-ls'
    local formatting = null_ls.builtins.formatting -- to setup formatters
    local diagnostics = null_ls.builtins.diagnostics -- to setup linters

    null_ls.builtins.formatters.prettierd.with {
      condition = function(utils)
        return utils.has_file {
          '.prettierrc',
          '.prettierrc.json',
          '.prettierrc.yaml',
          '.prettierrc.yml',
          '.prettierrc.js',
          '.prettierrc.cjs',
          '.prettierrc.config.js',
          '.prettierrc.config.cjs',
          'prettier.config.js',
          'prettier.config.cjs',
        }
      end,
    }
    -- list of formatters & linters for mason to install
    require('mason-null-ls').setup {
      ensure_installed = {
        'checkmake',
        'stylua', -- lua formatter
        'eslint_d', -- ts/js linter and formatter
        'shfmt',
        'prettierd',
        'ruff',
      },
      -- auto-install configured formatters & linters (with null-ls)
      automatic_installation = true,
    }

    local sources = {
      -- Use built-in checkmake
      diagnostics.checkmake,

      -- Use none-ls-extras version of eslint_d for both diagnostics and formatting
      require 'none-ls.diagnostics.eslint_d',
      require 'none-ls.formatting.eslint_d',

      -- Other formatters
      formatting.stylua,
      formatting.shfmt.with { args = { '-i', '4' } },
      formatting.terraform_fmt,
      require('none-ls.formatting.ruff').with { extra_args = { '--extend-select', 'I' } },
      require 'none-ls.formatting.ruff_format',
    }

    local augroup = vim.api.nvim_create_augroup('LspFormatting', {})
    null_ls.setup {
      -- debug = true, -- Enable debug mode. Inspect logs with :NullLsLog.
      sources = sources,
      -- you can reuse a shared lspconfig on_attach callback here
      on_attach = function(client, bufnr)
        if client.supports_method 'textDocument/formatting' then
          vim.api.nvim_clear_autocmds { group = augroup, buffer = bufnr }
          vim.api.nvim_create_autocmd('BufWritePre', {
            group = augroup,
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format { async = false }
            end,
          })
        end
      end,
    }
  end,
}
