local java = require("config.java")

local bufname = vim.api.nvim_buf_get_name(0)

local root_dir = java.project_root(bufname)
local project_name = vim.fn.fnamemodify(root_dir, ":t")
local workspace_dir = vim.fn.stdpath("data") .. "/jdtls-workspaces/" .. project_name
local jdtls_bin = vim.fn.stdpath("data") .. "/mason/packages/jdtls/bin/jdtls"
local bundles = java.mason_bundles()

if #bundles == 0 then
  vim.notify(
    "java-debug-adapter bundles not found. Run :Mason and install java-debug-adapter + java-test.",
    vim.log.levels.WARN
  )
end

local dap_opts = {
  hotcodereplace = "auto",
}

local config = {
  name = "jdtls",
  cmd = {
    jdtls_bin,
    "--java-executable",
    java.jdtls_java,
    "-data",
    workspace_dir,
  },
  root_dir = root_dir,
  settings = {
    java = {
      configuration = {
        runtimes = java.runtimes,
      },
    },
  },
  init_options = {
    bundles = bundles,
  },
  on_attach = function(_, bufnr)
    local opts = { buffer = bufnr, silent = true }
    vim.keymap.set("n", "<leader>tm", require("jdtls.dap").test_nearest_method, opts)
    vim.keymap.set("n", "<leader>tc", require("jdtls.dap").test_class, opts)
    vim.keymap.set("n", "<leader>tp", require("jdtls.dap").pick_test, opts)
    vim.keymap.set("n", "<leader>tj", "<cmd>JdtSetRuntime<cr>", vim.tbl_extend("force", opts, { desc = "Java: set JDK runtime" }))
  end,
}

require("jdtls").start_or_attach(config, { dap = dap_opts })
