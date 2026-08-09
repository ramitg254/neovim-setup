local M = {}

M.workspace_root = "/Users/ragupta/jdtls-workspace-dir"
M.jdtls_java = "/Library/Java/JavaVirtualMachines/openjdk-21.jdk/Contents/Home/bin/java"

M.default_runtime = "JavaSE-21"

function M.project_root(bufname)
  bufname = bufname or vim.api.nvim_buf_get_name(0)
  if bufname == "" then
    return vim.fn.getcwd()
  end

  local markers = {
    ".git",
    "gradlew",
    "mvnw",
    "pom.xml",
    "build.gradle",
    "build.gradle.kts",
  }

  local jdtls_setup = require("jdtls.setup")
  local root_dir = jdtls_setup.find_root(markers, bufname)
  if root_dir then
    return root_dir
  end

  local src_root = bufname:match("(.-)/src/")
  if src_root and src_root ~= "" then
    return src_root
  end

  return vim.fn.fnamemodify(bufname, ":p:h")
end

--- All installed JDKs for the project. Change active JDK with :JdtSetRuntime.
M.runtimes = {
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

function M.mason_bundles()
  local mason_path = vim.fn.stdpath("data") .. "/mason/packages"
  local bundles = {}

  local debug_jar = vim.fn.glob(
    mason_path .. "/java-debug-adapter/extension/server/com.microsoft.java.debug.plugin-*.jar",
    1
  )
  if debug_jar ~= "" then
    table.insert(bundles, debug_jar)
  end

  local java_test_bundles = vim.split(
    vim.fn.glob(mason_path .. "/java-test/extension/server/*.jar", 1),
    "\n",
    { plain = true }
  )
  local excluded = {
    ["com.microsoft.java.test.runner-jar-with-dependencies.jar"] = true,
    ["jacocoagent.jar"] = true,
  }
  for _, jar in ipairs(java_test_bundles) do
    local fname = vim.fn.fnamemodify(jar, ":t")
    if jar ~= "" and not excluded[fname] then
      table.insert(bundles, jar)
    end
  end

  return bundles
end

return M
