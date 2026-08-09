return {
  {
    "sindrets/diffview.nvim",
    cmd = {
      "DiffviewOpen",
      "DiffviewClose",
      "DiffviewToggleFiles",
      "DiffviewFocusFiles",
      "DiffviewRefresh",
      "DiffviewFileHistory",
    },
    keys = {
      { "<leader>gv", "<cmd>DiffviewOpen<cr>", desc = "Git diff: uncommitted changes" },
      { "<leader>gV", "<cmd>DiffviewClose<cr>", desc = "Git diff: close diffview" },
    },
    config = function()
      local actions = require("diffview.actions")

      require("diffview").setup({
        keymaps = {
          view = {
            { "n", "gR", actions.restore_entry, { desc = "Revert file to old version" } },
            { "n", "gu", function()
              vim.cmd("diffget")
            end, { desc = "Revert hunk (keep old/left side)" } },
          },
          file_panel = {
            { "n", "gu", actions.restore_entry, { desc = "Revert file to old version" } },
          },
        },
      })
    end,
  },
}
