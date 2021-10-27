-- plugin installation using packer
--
-- lsp
return require("packer").startup(function() 
	use "wbthomason/packer.nvim" -- works
	use {
		"neovim/nvim-lspconfig",
		requires = {
			{"hrsh7th/nvim-cmp"},
			{"hrsh7th/cmp-nvim-lsp"},
		}
	} -- works
	use "hrsh7th/cmp-buffer"
	use "hrsh7th/cmp-calc"
	use "hrsh7th/cmp-path"
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
        use { "nvim-treesitter/nvim-treesitter", 
		run = {":TSUpdate"},
	}
	use {"nvim-treesitter/nvim-treesitter-textobjects", opt = true }
	use { "nvim-treesitter/nvim-treesitter-refactor", opt = true }
	use { 
		"JoosepAlviste/nvim-ts-context-commentstring",
		requires = {"b3nj5m1n/kommentary"}
	}
	use { "p00f/nvim-ts-rainbow", opt = true }
	use { "romgrk/nvim-treesitter-context" }
	use "folke/twilight.nvim"
	use "folke/zen-mode.nvim"
	use { "windwp/nvim-ts-autotag" , opt = true }
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
--	use_rocks {"sqlite","luv"}
--	use {
 -- 		"nvim-telescope/telescope-frecency.nvim",
  --		requires = {"tami5/sqlite.lua"},
  --		config = function()
   -- 			require"telescope".load_extension("frecency")
  --		end
--	}

--
-- markdown
 --       use {"iamcco/markdown-preview.nvim", run = "cd app && yarn install", cmd = "MarkdownPreview"}
-- git
        use { "lewis6991/gitsigns.nvim",
      		requires = {{"nvim-lua/plenary.nvim"}},
		config = function()
    			require("gitsigns").setup()
  		end
	}
	use { "TimUntersberger/neogit",
  		requires = {{"nvim-lua/plenary.nvim"}},
		config = function()
    			require("neogit").setup()
  		end
	}
-- tabline
	use {"romgrk/barbar.nvim",
  		requires = {"kyazdani42/nvim-web-devicons"}
	}

end)
