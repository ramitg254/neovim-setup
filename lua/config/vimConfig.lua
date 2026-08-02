-- Set <space> as the leader key
-- See `:h mapleader`
-- NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '

-- OPTIONS
--
-- See `:h vim.o`
-- NOTE: You can change these options as you wish!
-- For more options, you can see `:h option-list`
-- To see documentation for an option, you can use `:h 'optionname'`, for example `:h 'number'`
-- (Note the single quotes)

vim.o.number = true -- Show line numbers in a column.

-- Show line numbers relative to where the cursor is.
-- Affects the 'number' option above, see `:h number_relativenumber`.
vim.o.relativenumber = true

-- Sync clipboard between OS and Neovim. Schedule the setting after `UIEnter` because it can
-- increase startup-time. Remove this option if you want your OS clipboard to remain independent.
-- See `:h 'clipboard'`
vim.api.nvim_create_autocmd('UIEnter', {
  callback = function()
    vim.o.clipboard = 'unnamedplus'
  end,
})

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.cursorline = true -- Highlight the line where the cursor is on.
vim.o.scrolloff = 10    -- Keep this many screen lines above/below the cursor.
vim.o.list = true       -- Show <tab> and trailing spaces.

-- If performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s). See `:h 'confirm'`
vim.o.confirm = true

-- KEYMAPS
--
-- See `:h vim.keymap.set()`, `:h mapping`, `:h keycodes`

-- Use <Esc> to exit terminal mode
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')

-- Map <A-j>, <A-k>, <A-h>, <A-l> to navigate between windows in any modes
vim.keymap.set({ 't', 'i' }, '<A-h>', '<C-\\><C-n><C-w>h')
vim.keymap.set({ 't', 'i' }, '<A-j>', '<C-\\><C-n><C-w>j')
vim.keymap.set({ 't', 'i' }, '<A-k>', '<C-\\><C-n><C-w>k')
vim.keymap.set({ 't', 'i' }, '<A-l>', '<C-\\><C-n><C-w>l')
vim.keymap.set({ 'n' }, '<A-h>', '<C-w>h')
vim.keymap.set({ 'n' }, '<A-j>', '<C-w>j')
vim.keymap.set({ 'n' }, '<A-k>', '<C-w>k')
vim.keymap.set({ 'n' }, '<A-l>', '<C-w>l')

-- Tmux-style splits using Leader key
vim.keymap.set('n', '<leader>%', ':vsplit<CR>', { desc = 'Split window vertically (tmux-style)' })
vim.keymap.set('n', '<leader>"', ':split<CR>', { desc = 'Split window horizontally (tmux-style)' })

-- AUTOCOMMANDS (EVENT HANDLERS)
--
-- See `:h lua-guide-autocommands`, `:h autocmd`, `:h nvim_create_autocmd()`

-- Highlight when yanking (copying) text.
-- Try it with `yap` in normal mode. See `:h vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  callback = function()
    vim.hl.on_yank()
  end,
})

-- Keymaps to copy file paths to clipboard

-- 1. Copy Relative Path (e.g., lua/plugins/lsp.lua)
vim.keymap.set("n", "<leader>cp", function()
  local path = vim.fn.expand("%")
  vim.fn.setreg("+", path)
  vim.notify("Copied relative path: " .. path)
end, { desc = "Copy relative path" })

-- 2. Copy Absolute Path (e.g., /home/user/.config/nvim/lua/plugins/lsp.lua)
vim.keymap.set("n", "<leader>cP", function()
  local path = vim.fn.expand("%:p")
  vim.fn.setreg("+", path)
  vim.notify("Copied absolute path: " .. path)
end, { desc = "Copy absolute path" })

-- 3. Copy Filename Only (e.g., lsp.lua)
vim.keymap.set("n", "<leader>cf", function()
  local file = vim.fn.expand("%:t")
  vim.fn.setreg("+", file)
  vim.notify("Copied filename: " .. file)
end, { desc = "Copy filename" })

-- USER COMMANDS: DEFINE CUSTOM COMMANDS
--
-- See `:h nvim_create_user_command()` and `:h user-commands`

-- Create a command `:GitBlameLine` that print the git blame for the current line
vim.api.nvim_create_user_command('GitBlameLine', function()
  local line_number = vim.fn.line('.') -- Get the current line number. See `:h line()`
  local filename = vim.api.nvim_buf_get_name(0)
  print(vim.system({ 'git', 'blame', '-L', line_number .. ',+1', filename }):wait().stdout)
end, { desc = 'Print the git blame for the current line' })

-- Quick FZF-Lua Keymaps
vim.keymap.set('n', '<leader>ff', '<cmd>FzfLua files<CR>', { desc = 'FZF Find Files' })
vim.keymap.set('n', '<leader>fg', '<cmd>FzfLua live_grep<CR>', { desc = 'FZF Live Grep' })
vim.keymap.set('n', '<leader>fb', '<cmd>FzfLua buffers<CR>', { desc = 'FZF Buffers' })

-- nvim-lspconfig keymaps
vim.api.nvim_create_autocmd("LspAttach", {
  group = vim.api.nvim_create_augroup("UserLspConfig", { clear = true }),
  callback = function(event)
    -- Helper function with buffer-local isolation
    local map = function(mode, keys, func, desc)
      vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
    end

    -- Navigation
    map("n", "<leader>gd", vim.lsp.buf.definition, "Go to Definition")
    map("n", "<leader>gD", vim.lsp.buf.declaration, "Go to Declaration")
    map("n", "<leader>gi", vim.lsp.buf.implementation, "Go to Implementation")
    map("n", "<leader>gr", vim.lsp.buf.references, "Go to References")
    map("n", "<leader>gt", vim.lsp.buf.type_definition, "Go to Type Definition")

    -- Documentation & Info
    map("n", "<leader>k", vim.lsp.buf.hover, "Hover Documentation")
    map("n", "<leader>sh", vim.lsp.buf.signature_help, "Signature Help")

    -- Actions & Refactoring
    map("n", "<leader>rn", vim.lsp.buf.rename, "Rename Symbol")
    map({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, "Code Action")

    -- Formatting
    map("n", "<leader>fm", function()
      vim.lsp.buf.format({ async = true })
    end, "Format Buffer")

    -- Diagnostics Navigation & Info
    map("n", "<leader>dp", vim.diagnostic.goto_prev, "Previous Diagnostic")
    map("n", "<leader>dn", vim.diagnostic.goto_next, "Next Diagnostic")
    map("n", "<leader>e", vim.diagnostic.open_float, "Open Line Diagnostics")
    map("n", "<leader>q", vim.diagnostic.setloclist, "Open Diagnostics List")
  end,
})
