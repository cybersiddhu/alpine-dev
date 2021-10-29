-- nvim-cmp setup
local cmp = require "cmp"
local luasnip = require "luasnip"
local has_words_before = function()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end
cmp.setup {
	mapping = {
		["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
    		["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
		["Down"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
		["Up"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
    		["<C-d>"] = cmp.mapping.scroll_docs(-4),
    		["<C-f>"] = cmp.mapping.scroll_docs(4),
    		["<C-Space>"] = cmp.mapping.complete(),
    		["<C-e>"] = cmp.mapping.close(),
    		["<CR>"] = cmp.mapping.confirm {
      			behavior = cmp.ConfirmBehavior.Replace,
      			select = true,
    		},
		["<Tab>"] = cmp.mapping(function(fallback)
      			if cmp.visible() then
        			cmp.select_next_item()
      			elseif luasnip.expand_or_jumpable() then
				luasnip.expand_or_jump()
			elseif has_words_before() then
				cmp.complete()
      			else
        			fallback()
      			end
    		end, {"i","s"}),
		['<S-Tab>'] = cmp.mapping(function(fallback)
      			if cmp.visible() then
        			cmp.select_prev_item()
      			elseif luasnip.jumpable(-1) then
				luasnip.jump(-1)
      			else
        			fallback()
      			end
    		end,{"i","s"}),
	},
	sources = cmp.config.sources({
		{name = "nvim_lsp"}, 
		{name = "luasnip"},
        	{name = "buffer"}, 
        	{name = "look"}, 
		{name = "path"},
         	{name = "calc"}, 
		{name = "spell"},
        	{name = "emoji"},
		{name = "dictionary"}
    	}),
	snippet = {
		expand = function(args) 
			luasnip.lsp_expand(args.body)
		end,
	},
	formatting = {
		format = function(entry, vim_item)
        		vim_item.kind = require("lspkind").presets.default[vim_item.kind] .. " " .. vim_item.kind
			vim_item.menu = ({
			  buffer = "[Buffer]",
			  nvim_lsp = "[LSP]",
			  luaship = "[LuaSnips]",
			  look = "[Look]",
			  path = "[Path]",
			  spell = "[Spell]",
			  calc = "[Calc]",
			  emoji = "[Emoji]",
			  dictionary = "[Dictionary]",
			})[entry.source.name]
        		return vim_item
      		end,
	},
}
require("luasnip.loaders.from_vscode").load()
-- lsp and related configuration
local nvim_lsp = require "lspconfig"
local cmp_nvim_lsp = require "cmp_nvim_lsp"
local on_attach = function(client,bufnr)
	local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr,...) end
	local opts = { noremap = true, silent = true}
	buf_set_keymap("n","U","<cmd>lua vim.lsp.buf.hover()<CR>",opts)
	buf_set_keymap("n", "<space>a", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", opts)
	buf_set_keymap("n", "[c", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", opts)
	buf_set_keymap("n", "]c", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", opts)
	buf_set_keymap("n", "ds", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
	buf_set_keymap("n", "pc", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
	buf_set_keymap("n", "pi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
	buf_set_keymap("n", "pr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
	buf_set_keymap("n", "<Leader>pn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
	buf_set_keymap("n", "<Leader>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
	buf_set_keymap("x", "<Leader>f", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
	buf_set_keymap("v", "<Leader>f", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
	buf_set_keymap("n", "<Leader>a", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
	buf_set_keymap("x", "<Leader>a", "<cmd>lua vim.lsp.buf.range_code_action()<CR>", opts)
	buf_set_keymap("v", "<Leader>a", "<cmd>lua vim.lsp.buf.range_code_action()<CR>", opts)
	buf_set_keymap("n", "S", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
end
for _,lsp in ipairs({"tsserver","html","graphql","eslint", "dockerls"}) do
	nvim_lsp[lsp].setup{
		on_attach = on_attach,
		capabilities = cmp_nvim_lsp.update_capabilities(vim.lsp.protocol.make_client_capabilities()),
	}
end

	
