-- plugin installation using packer
return require("packer").startup(function() 
	use "wbthomason/packer.nvim" -- works
-- treesitter
        use { 
		{ "nvim-treesitter/nvim-treesitter", run = {":TSUpdate"}},
		{"nvim-treesitter/nvim-treesitter-textobjects", after = "nvim-treesitter" },
		{ "nvim-treesitter/nvim-treesitter-refactor", after = "nvim-treesitter-textobjects" },
		{ "windwp/nvim-ts-autotag", after = "nvim-treesitter-refactor" },
		{ "p00f/nvim-ts-rainbow" ,
			after = "nvim-ts-autotag",
			config = function()
				require("config.treesitter")
				require("config.folding")
			end
		},
		{ "JoosepAlviste/nvim-ts-context-commentstring",
			after = "nvim-ts-rainbow",
			requires = {"b3nj5m1n/kommentary"},
			config = [[require("config.comment")]],
		},
		{ "romgrk/nvim-treesitter-context", 
			after = "nvim-ts-context-commentstring",
			config = [[require("config.treesitter_context")]],
		}, -- works
		{ "folke/zen-mode.nvim", 
			after = "nvim-treesitter-context",
			requires = { "folke/twilight.nvim"},
			config = function()
				require("zen-mode").setup({})
				require("utils").map("n","<Leader>zm","<Cmd>ZenMode<CR>")
			end
		},
       		{ "shaunsingh/nord.nvim", 
			event = "VimEnter", 
			config = "vim.cmd[[colorscheme nord]]",
		}, 
	}
-- lsp and snipetts
	use {
		{"rescript-lang/vim-rescript"},
		{"hrsh7th/nvim-cmp"},
		{"hrsh7th/cmp-nvim-lsp",
			requires = {"neovim/nvim-lspconfig"},
			config = [[require("config.lsp")]],
		},
		{"hrsh7th/cmp-buffer"}, -- works
		{"f3fora/cmp-spell"}, -- works,
		{"hrsh7th/cmp-calc"},
		{"hrsh7th/cmp-path"},
		{"hrsh7th/cmp-nvim-lsp-document-symbol"},
		{"hrsh7th/cmp-cmdline"},
--		{"uga-rosa/cmp-dictionary"},
		{"octaltree/cmp-look"},
		{"ray-x/cmp-treesitter"},
		{"onsails/lspkind-nvim"}, -- works
		{"L3MON4D3/LuaSnip",
			requires = {
				{"saadparwaiz1/cmp_luasnip"},
				{"rafamadriz/friendly-snippets"},
			},
			config = function()
				require("config.autocomplete")
				require("luasnip.loaders.from_vscode").load()
			end,
		}, -- works
		-- tagbar like 
		{"liuchengxu/vista.vim",
			config = function()
				require("utils").map("n","<Leader>vt","<Cmd>Vista!!<CR>")
				vim.api.nvim_set_var("vista_default_executive","nvim_lsp")
			end
		},
	}
-- telescope
	use { 
		{ "nvim-telescope/telescope.nvim", requires = {"nvim-lua/plenary.nvim"}},	
		{ "nvim-telescope/telescope-file-browser.nvim" },
		{ "nvim-telescope/telescope-fzf-native.nvim", 
			run = "make",
			config = [[require("config.telescope")]],
		}, 
		{ "nvim-telescope/telescope-symbols.nvim" },
	}
-- git
       use {  
		{ "lewis6991/gitsigns.nvim",
			config = function()
				require("gitsigns").setup({current_line_blame = true})
				vim.cmd[[highlight default link GitSignsCurrentLineBlame LineNr]]
				require("utils").map("n","<Leader>cb","<Cmd>Gitsigns toggle_current_line_blame<CR>")
			end
		},
		{ "TimUntersberger/neogit",
			cmd = "Neogit",
			config = function()
				require("neogit").setup({disable_commit_confirmation = true})
				require("utils").map("n","<Leader>ng","<Cmd>Neogit<CR>")
			end		
		},
	}
-- tabline
	use { "romgrk/barbar.nvim",
  		requires = {"kyazdani42/nvim-web-devicons"},
		config = [[require("config.tabline")]],
	}
-- hop 
	use { "phaazon/hop.nvim", config = [[require("config.hop")]] }
-- notify
	use { "rcarriga/nvim-notify",
      		event = "VimEnter",
      		config = function()
        		vim.notify = require("notify")
      		end,
	}
-- statusline
	use { "nvim-lualine/lualine.nvim", 
		event = "VimEnter",
		config = [[require("config.lualine")]],
	}
-- terminal
	use { "voldikss/vim-floaterm", 
		event = "VimEnter",
		config = [[require("config.floaterm")]],
	}
-- editor configuration
	use { "editorconfig/editorconfig-vim" }
-- autopair
	use { "windwp/nvim-autopairs",
		config = function()
			require('nvim-autopairs').setup{}
		end
	}
end)