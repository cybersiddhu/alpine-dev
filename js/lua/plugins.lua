-- plugin installation using packer
return require("packer").startup(function() 
	use "wbthomason/packer.nvim" -- works
-- lsp and snipetts
	use {
		{"hrsh7th/nvim-cmp"},
		{"hrsh7th/cmp-nvim-lsp",
			requires = {"neovim/nvim-lspconfig"},
			config = [[require("config.lsp")]],
		},
		{"hrsh7th/cmp-buffer", after = "nvim-cmp"}, -- works
		{"f3fora/cmp-spell", after = "nvim-cmp"}, -- works,
		{"hrsh7th/cmp-calc", after = "nvim-cmp"},
		{"hrsh7th/cmp-path", after = "nvim-cmp"},
		{"uga-rosa/cmp-dictionary", after = "nvim-cmp"},
		{"octaltree/cmp-look", after = "nvim-cmp"},
		{"onsails/lspkind-nvim", after = "nvim-cmp"}, -- works
		{"L3MON4D3/LuaSnip",
			requires = {
				{"saadparwaiz1/cmp_luasnip"},
				{"rafamadriz/friendly-snippets"},
			},
			after = "lspkind-nvim",
			config = [[require("config.autocomplete")]],
		}, -- works
	}
        use { 
		{ "nvim-treesitter/nvim-treesitter", 
			run = {":TSUpdate"},
		},
		{"nvim-treesitter/nvim-treesitter-textobjects" , after = "nvim-treesitter" },
		{ "nvim-treesitter/nvim-treesitter-refactor", after = "nvim-treesitter-textobjects" },
		{ "windwp/nvim-ts-autotag" , after = "nvim-treesitter-refactor" },
		{ "p00f/nvim-ts-rainbow" ,
			after = "nvim-ts-autotag",
			config = function()
				require("config.treesitter")
				require("config.folding")
			end
		},
		{ "JoosepAlviste/nvim-ts-context-commentstring",
			requires = {"b3nj5m1n/kommentary"},
			after = "nvim-ts-rainbow",
			config = [[require("config.comment")]],
		},
		{ "romgrk/nvim-treesitter-context",
			after = "nvim-ts-context-commentstring",
			config = [[require("config.treesitter_context")]],
		}, -- works
		{ "folke/zen-mode.nvim", 
			requires = { "folke/twilight.nvim" },
			after = "nvim-treesitter-context",
		},
       		{ "shaunsingh/nord.nvim", event = "VimEnter", config = "vim.cmd[[colorscheme nord]]" }, 
	}
-- telescope
	use { "nvim-telescope/telescope.nvim",
		requires = {"nvim-lua/plenary.nvim"},
		config = [[require("config.telescope")]],
	}
-- git
        use {  
		{ "lewis6991/gitsigns.nvim",
      			requires = {"nvim-lua/plenary.nvim"},
			config = function()
				require("gitsigns").setup()
			end
		},
		{ "TimUntersberger/neogit",
			commit = "a7eba973974018b4fed5076ffdc6cdf03e368904",
			requires = {"nvim-lua/plenary.nvim"},
			cmd = "Neogit",
			config = function()
				require("neogit").setup({disable_commit_confirmation = true})
				require("utils").map("n","<Leader>gs","Neogit<CR>")
			end
		},
	}
-- tabline
	use { "romgrk/barbar.nvim",
  		requires = {"kyazdani42/nvim-web-devicons"},
		config = [[require("config.tabline")]],
	}
end)
