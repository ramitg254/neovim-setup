return {
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      dapui.setup()

      local function float_panel(element)
        dapui.float_element(element, { enter = true })
      end

      vim.keymap.set("n", "<leader>dc", dap.continue, { desc = "Debug: Continue / Start" })
      vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint, { desc = "Debug: Toggle Breakpoint" })
      vim.keymap.set("n", "<leader>dB", function()
        local condition = vim.fn.input("Breakpoint condition: ")
        if condition ~= "" then
          dap.set_breakpoint(condition)
        end
      end, { desc = "Debug: Conditional Breakpoint" })
      vim.keymap.set("n", "<leader>ds", dap.step_over, { desc = "Debug: Step Over" })
      vim.keymap.set("n", "<leader>di", dap.step_into, { desc = "Debug: Step Into" })
      vim.keymap.set("n", "<leader>dO", dap.step_out, { desc = "Debug: Step Out" })
      vim.keymap.set("n", "<leader>du", dapui.toggle, { desc = "Debug: Toggle UI" })
      vim.keymap.set("n", "<leader>dsc", function()
        float_panel("scopes")
      end, { desc = "Debug: Float Scopes" })
      vim.keymap.set("n", "<leader>dst", function()
        float_panel("stacks")
      end, { desc = "Debug: Float Stacks" })
      vim.keymap.set("n", "<leader>dbp", function()
        float_panel("breakpoints")
      end, { desc = "Debug: Float Breakpoints" })
      vim.keymap.set("n", "<leader>dw", function()
        float_panel("watches")
      end, { desc = "Debug: Float Watches" })
      vim.keymap.set("n", "<leader>dr", function()
        float_panel("repl")
      end, { desc = "Debug: Float REPL" })
      vim.keymap.set("n", "<leader>dco", function()
        float_panel("console")
      end, { desc = "Debug: Float Console" })
      vim.keymap.set("n", "<leader>dx", dap.terminate, { desc = "Debug: Terminate" })

      dap.configurations.java = dap.configurations.java or {}
    end,
  },
}
