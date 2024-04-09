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
    end,
  },
}
