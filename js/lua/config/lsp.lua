-- lsp and related configuration
local nvim_lsp = require "lspconfig"
local cmp_nvim_lsp = require "cmp_nvim_lsp"
local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr,...) end
local function keymaps_on_attach()
	local opts = { noremap = true, silent = true}
	buf_set_keymap("n","U","<cmd>lua vim.lsp.buf.hover()<CR>",opts)
	buf_set_keymap("n", "S", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
	buf_set_keymap("n", "<space>a", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", opts)
	buf_set_keymap("n", "[c", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", opts)
	buf_set_keymap("n", "]c", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", opts)
	buf_set_keymap("n", "pd", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
	buf_set_keymap("n", "pc", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
	buf_set_keymap("n", "pi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
	buf_set_keymap("n", "pr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
	buf_set_keymap("n", "<Leader>pn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
	buf_set_keymap("n", "<Leader>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
	buf_set_keymap("x", "<Leader>f", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
	buf_set_keymap("v", "<Leader>f", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
	buf_set_keymap("n", "<Leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
	buf_set_keymap("x", "<Leader>ca", "<cmd>lua vim.lsp.buf.range_code_action()<CR>", opts)
	buf_set_keymap("v", "<Leader>ca", "<cmd>lua vim.lsp.buf.range_code_action()<CR>", opts)
end
local on_attach = function(client,bufnr)
	keymaps_on_attach()
end
for _,lsp in ipairs({"html","graphql","eslint", "dockerls", "jsonls", "yamlls"}) do
	nvim_lsp[lsp].setup{
		on_attach = on_attach,
		capabilities = cmp_nvim_lsp.update_capabilities(vim.lsp.protocol.make_client_capabilities()),
	}
end
local rescript_server_path = function()
	local base_path = os.getenv("XDG_DATA_HOME") .. "/nvim" .. "/site" .. "/pack" .. "/packer" .. "/start"
	return base_path .. "/vim-rescript" .. "/server" .. "/out" .. "/server.js"
end
nvim_lsp.rescriptls.setup{
	on_attach = on_attach,
	capabilities = cmp_nvim_lsp.update_capabilities(vim.lsp.protocol.make_client_capabilities()),
	cmd = {"node", rescript_server_path(), "--stdio"}
}
local on_attach_tsserver = function(client, bufnr)
	client.resolved_capabilities.document_formatting = false
        client.resolved_capabilities.document_range_formatting = false
	keymaps_on_attach()
end
nvim_lsp.tsserver.setup{
	on_attach = on_attach_tsserver,
	capabilities = cmp_nvim_lsp.update_capabilities(vim.lsp.protocol.make_client_capabilities()),
}
