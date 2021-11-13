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
