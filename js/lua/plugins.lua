-- plugin installation using packer
--
-- lsp
return require("packer").startup(function() 
	use "wbthomason/packer.nvim"
	use {
		"neovim/nvim-lspconfig",
		requires = {
			{"hrsh7th/nvim-cmp"},
			{"hrsh7th/cmp-nvim-lsp"},
		}
	}
	use "hrsh7th/cmp-buffer"
	use "hrsh7th/cmp-calc"
	use "hrsh7th/nvim-path"
	use "f3fora/cmp-spell"
	use "uga-rosa/cmp-dictionary"
	use "octaltree/cmp-look"
	use {
		"L3MON4D3/LuaSnip",
		requires = {
			{"saadparwaiz1/cmp_luasnip"},
			{"rafamadriz/friendly-snippets"},
		}
	}
	use "onsails/lspkind-nvim"
-- treesitter
        use { "nvim-treesitter/nvim-treesitter", run = ":TSUpdate" }
	use "nvim-treesitter/nvim-treesitter-textobjects"
	use "nvim-treesitter/nvim-treesitter-refactor"
	use { 
		"JoosepAlviste/nvim-ts-context-commentstring",
		requires = {
			{"b3nj5m1n/kommentary"}

		}
	}
	use "p00f/nvim-ts-rainbow"
	use "romgrk/nvim-treesitter-context"
	use "folke/twilight.nvim"
	use "folke/zen-mode.nvim"
	use "windwp/nvim-ts-autotag" 
	use "shaunsingh/nord.nvim"
--	"mfussenegger/nvim-ts-hint-textobject"
--	"RRethy/nvim-treesitter-textsubjects"
-- telescope
	use {
		"nvim-telescope/telescope.nvim",
		requires = {
			{"nvim-lua/plenary.nvim"}
		}
	}
--	{"nvim-telescope/telescope-fzf-native.nvim", run = "make"}
--	"tami5/sqlite.lua"
--	"nvim-telescope/telescope-frecency.nvim"
--
-- markdown
        use {"iamcco/markdown-preview.nvim", run = "cd app && yarn install", cmd = "MarkdownPreview"}
end)
