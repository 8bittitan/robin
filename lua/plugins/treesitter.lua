return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = { "windwp/nvim-ts-autotag" },
    build = ":TSUpdate",
    config = function()
      require("nvim-ts-autotag").setup()
      local config = require("nvim-treesitter.configs")
      config.setup({
        auto_tag = {
          enable = true,
        },
        auto_install = true,
        highlight = { enable = true },
        indent = { enable = true },
      })

      local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
      parser_config.blade = {
        install_info = {
          url = "https://github.com/EmranMR/tree-sitter-blade",
          files = { "src/parser.c" },
          branch = "main",
        },
        filetype = "blade",
      }

      local augroup = vim.api.nvim_create_augroup("lsp_blade_workaround", { clear = true })

      vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
        group = augroup,
        pattern = "*.blade.php",
        callback = function()
          vim.bo.filetype = "php"
        end,
      })

      vim.api.nvim_create_autocmd("LspAttach", {
        pattern = "*.blade.php",
        callback = function(args)
          vim.schedule(function()
            -- Check if the attached client is 'intelephense'
            for _, client in ipairs(vim.lsp.get_active_clients()) do
              if client.name == "intelephense" and client.attached_buffers[args.buf] then
                vim.api.nvim_buf_set_option(args.buf, "filetype", "blade")
                -- update treesitter parser to blade
                vim.api.nvim_buf_set_option(args.buf, "syntax", "blade")
                break
              end
            end
          end)
        end,
      })

      vim.api.nvim_exec(
        [[
autocmd FileType php set iskeyword+=$
]],
        false
      )
    end,
  },
}
