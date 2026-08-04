-- If you started neovim within `~/dev/xy/project-1` this would resolve to `project-1`
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')

local workspace_dir = '/Users/ragupta/jdtls-workspace-dir/' .. project_name
local jdtls_bin = "/Users/ragupta/.local/share/nvim/mason/packages/jdtls/bin/jdtls"

local bundles = {
  vim.fn.glob(
    "/Users/ragupta/.local/share/nvim/mason/packages/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar",
    1)
}

local java_test_bundles = vim.split(
vim.fn.glob("/Users/ragupta/.local/share/nvim/mason/packages/java-test/extension/server/*.jar", 1), "\n")
local excluded = {
  "com.microsoft.java.test.runner-jar-with-dependencies.jar",
  "jacocoagent.jar",
}
for _, java_test_jar in ipairs(java_test_bundles) do
  local fname = vim.fn.fnamemodify(java_test_jar, ":t")
  if not vim.tbl_contains(excluded, fname) then
    table.insert(bundles, java_test_jar)
  end
end
-- See `:help vim.lsp.start` for an overview of the supported `config` options.
local config = {
  name = "jdtls",

  -- `cmd` defines the executable to launch eclipse.jdt.ls.
  -- `jdtls` must be available in $PATH and you must have Python3.9 for this to work.
  --
  -- As alternative you could also avoid the `jdtls` wrapper and launch
  -- eclipse.jdt.ls via the `java` executable
  -- See: https://github.com/eclipse/eclipse.jdt.ls#running-from-the-command-line
  cmd = { jdtls_bin,
    '-data', workspace_dir },


  -- `root_dir` must point to the root of your project.
  -- See `:help vim.fs.root`
  root_dir = vim.fs.root(0, { 'gradlew', '.git', 'mvnw' }),


  -- Here you can configure eclipse.jdt.ls specific settings
  -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
  -- for a list of options
  settings = {
    java = {
      configuration = {
        -- See https://github.com/eclipse/eclipse.jdt.ls/wiki/Running-the-JAVA-LS-server-from-the-command-line#initialize-request
        -- And search for `interface RuntimeOption`
        -- The `name` is NOT arbitrary, but must match one of the elements from `enum ExecutionEnvironment` in the link above
        runtimes = {
          {
            name = "JavaSE-1.8",
            path = "/Library/Java/JavaVirtualMachines/temurin-8.jdk/Contents/Home",
          },
          {
            name = "JavaSE-17",
            path = "/Library/Java/JavaVirtualMachines/jdk-17.jdk/Contents/Home",
          },
          {
            name = "JavaSE-21",
            path = "/Library/Java/JavaVirtualMachines/openjdk-21.jdk/Contents/Home",
            default = true,
          },
        }
      }
    }
  },


  -- This sets the `initializationOptions` sent to the language server
  -- If you plan on using additional eclipse.jdt.ls plugins like java-debug
  -- you'll need to set the `bundles`
  --
  -- See https://codeberg.org/mfussenegger/nvim-jdtls#java-debug-installation
  --
  -- If you don't plan on any eclipse.jdt.ls plugins you can remove this
  init_options = {
    bundles = bundles
  },

  on_attach = function(client, bufnr)
    -- This binds the java-debug-adapter to nvim-dap
    require('jdtls').setup_dap({ hotcodereplace = 'auto' })

    -- Map your testing shortcuts directly to the active Java buffer
    local opts = { silent = true, buffer = bufnr }
    vim.keymap.set('n', '<leader>tm', function() require('jdtls').test_nearest_method() end, opts)
    vim.keymap.set('n', '<leader>tc', function() require('jdtls').test_class() end, opts)
  end,
}
require('jdtls').start_or_attach(config)

local dap = require("dap")
dap.configurations.java = {
  {
    type = "java",
    request = "launch",
    name = "Debug Standalone File",
    mainClass = "${file}",
    projectName = project_name,
    javaExec = "/Library/Java/JavaVirtualMachines/openjdk-21.jdk/Contents/Home",
  },

}
