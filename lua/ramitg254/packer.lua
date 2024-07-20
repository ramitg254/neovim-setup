-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  use {
	  'nvim-telescope/telescope.nvim', tag = '0.1.8',
	  -- or                            , branch = '0.1.x',
	  requires = { {'nvim-lua/plenary.nvim'} }
  }

  use({ 'rose-pine/neovim',
         as = 'rose-pine', 
         config = function()
	  	vim.cmd('colorscheme rose-pine')
         end
  })

  use('nvim-treesitter/nvim-treesitter', {run= ':TSUpdate'})
  use('ThePrimeagen/harpoon')
  use('nvim-treesitter/playground')
  use('mbbill/undotree')
  use('tpope/vim-fugitive')

  use{'VonHeikemen/lsp-zero.nvim',
  	requires= {
		--LSP Support
		{'neovim/nvim-lspconfig'},
		{'williamboman/mason.nvim'},
		{'williamboman/mason-lspconfig.nvim'},
        {'ray-x/lsp_signature.nvim'},
        
		--Autocompletion
		{'hrsh7th/nvim-cmp'},
		{'hrsh7th/cmp-nvim-lsp'},
		{'hrsh7th/cmp-nvim-lua'},
		{'hrsh7th/cmp-buffer'},
		{'hrsh7th/cmp-path'},
		{'saadparwaiz1/cmp_luasnip'},

		--Snippets
		{'L3MON4D3/LuaSnip'},
		{'rafamadriz/friendly-snippets'}
	}
  }

  use {
      'numToStr/Comment.nvim',
      config = function()
          require('Comment').setup()
      end
  }

  
  use 'mfussenegger/nvim-dap' -- Nvim dap
  use 'rcarriga/nvim-dap-ui' -- Better UI for DAP
  use 'theHamsta/nvim-dap-virtual-text' -- Better UI for DAP

  use 'CRAG666/code_runner.nvim'
  use 'jiangmiao/auto-pairs'

  use {
      'xeluxee/competitest.nvim',
      requires = 'MunifTanjim/nui.nvim',
      config = function() require('competitest').setup() end
  }
 end)
