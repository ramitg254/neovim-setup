return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
      on_attach = function(bufnr)
        local gs = require("gitsigns")

        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
        end

        -- Hunk navigation (with auto-preview of old version)
        map("n", "<leader>hk", function()
          gs.nav_hunk("prev", { preview = true })
        end, "Git: prev hunk + preview")
        map("n", "<leader>hj", function()
          gs.nav_hunk("next", { preview = true })
        end, "Git: next hunk + preview")

        -- Preview old vs new
        map("n", "<leader>hp", gs.preview_hunk, "Git: preview hunk (popup)")

        -- Revert / stage hunks
        map("n", "<leader>hr", gs.reset_hunk, "Git: revert hunk")
        map("n", "<leader>hs", gs.stage_hunk, "Git: stage hunk")

        -- Whole buffer
        map("n", "<leader>hS", gs.stage_buffer, "Git: stage buffer")
        map("n", "<leader>hR", gs.reset_buffer, "Git: revert buffer")

        -- Blame & diff
        map("n", "<leader>hb", function()
          gs.blame_line({ full = true })
        end, "Git: blame line (full hunk)")

        -- Quickfix
        map("n", "<leader>hq", gs.setqflist, "Git: hunks to loclist")
        map("n", "<leader>hQ", function()
          gs.setqflist("all")
        end, "Git: all hunks to loclist")

        -- Toggles
        map("n", "<leader>tb", gs.toggle_current_line_blame, "Git: toggle line blame")
      end,
    },
  },
}
