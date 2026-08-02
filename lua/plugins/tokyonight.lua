
return {
  -- the colorscheme should be available when starting Neovim
  {
    "folke/tokyonight.nvim",
    lazy = false, -- make sure we load this during startup if it is your main colorscheme
    priority = 1000, -- make sure to load this before all the other start plugins
    opts = {
      transparent = true, -- enables transparency for TokyoNight
      styles = {
        sidebars = "transparent", -- makes nvim-tree, neo-tree, etc. transparent
        floats = "transparent", -- makes floating windows transparent
      },
    },
    config = function(_, opts)
      -- pass the options to the setup function
      require("tokyonight").setup(opts)
      -- load the colorscheme here
      vim.cmd([[colorscheme tokyonight]])
    end,
  }
}
