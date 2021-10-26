-- treesitter configuration
local tree_config = require "nvim-treesitter.configs"
local text_objects = {
	select = {
		enable = true,
		lookahead = true,
		keymaps = {
			["af"] = "@function.outer",
			["if"] = "@function.inner",
			["ac"] = "@class.outer",
			["ic"] = "@class.inner",
		},
	},
	swap = {
		enable = true,
		swap_next = {
			["<leader>a"] = "@parameter.inner",
		},
		swap_previous = {
			["<leader>A"] = "@parameter.inner",
		},
	},
	move = {
		enable = true,
		goto_next_start = {
			["]m"] = "@function.outer",
			["]]"] = "@class.outer",
		},
		goto_next_end = {
			["]M"] = "@function.outer",
			["]["] = "@class.outer",
		},
		goto_previous_start = {
			["[m"] = "@function.outer",
			["[["] = "@class.outer",
		},
		goto_previous_end = {
			["[M"] = "@function.outer",
			["[]"] = "@class.outer",
		},
	},
	lsp_interop = {
		enable = true,
		border = "none",
		peek_definition_code = {
			["<leader>df"] = "@function.outer",
			["<leader>dF"] = "@class.outer",
		},
	},
}
local refactor = {
	highlight_definitions = { enable = true },
	highlight_current_scope = { enable = true },
	smart_rename = {
      		enable = true,
      		keymaps = {
        		smart_rename = "grr",
      		},
	},
	navigation = {
		enable = true,
		keymaps = {
        		goto_definition = "gnd",
        		list_definitions = "gnD",
        		list_definitions_toc = "gO",
        		goto_next_usage = "<a-*>",
        		goto_previous_usage = "<a-#>",
      		},
	},
}
local rainbow = {
	enable = true,
	extended_mode = true,
	max_file_lines = nil,
}
tree_config.setup {
	highlight = { enable = true },
	incremental_selection = { enable = true },
	indent = { enable = true },
	textobjects = text_objects, 
	refactor = refactor,
	rainbow = rainbow,
	autotag = { enable = true },
	context_commentstring = {
    		enable = true,
    		enable_autocmd = false,
  	},
}
-- integration with kommentary plugin
require("kommentary.config").configure_language("typescriptreact", {
  single_line_comment_string = "auto",
  multi_line_comment_strings = "auto",
  hook_function = function()
    require("ts_context_commentstring.internal").update_commentstring()
  end,
})
require("treesitter-context").setup{
	enable = true,
	throttle = true,
	max_lines = 0,
	pattern = {
		default = {"class","function","method"},
	},
}
