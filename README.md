# Neovim Configuration

Neovim configuration with Lazy plugin manager.

## Installation

1. Create the Neovim configuration directory:

   ```bash
   mkdir -p ~/.config/nvim
   ```

2. Remove any existing configuration:

   ```bash
   rm -rf ~/.config/nvim/* ~/.config/nvim/.* 2>/dev/null
   ```

3. Copy this repository to the Neovim configuration directory:

   ```bash
   cp -r . ~/.config/nvim/
   rm -f ~/.config/nvim/README.md
   ```

### Note: language server binaries which interact with lsp plugin needs to be installed via mason plugin
