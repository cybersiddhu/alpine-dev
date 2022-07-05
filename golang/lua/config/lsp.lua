-- lsp and related configuration
local nvim_lsp = require "lspconfig"
local cmp_nvim_lsp = require "cmp_nvim_lsp"
local buf_set_keymap = vim.api.nvim_buf_set_keymap
local function keymaps_on_attach(bufnr)
	local opts = { noremap = true, silent = true}
	buf_set_keymap(bufnr, "n", "[c", "<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>", opts)
	buf_set_keymap(bufnr, "n", "]c", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", opts)
	buf_set_keymap(bufnr, "n", "<space>a", "<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>", opts)
	buf_set_keymap(bufnr, "n","U","<cmd>lua vim.lsp.buf.hover()<CR>",opts)
	buf_set_keymap(bufnr, "n", "S", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
	buf_set_keymap(bufnr, "n", "pd", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)
	buf_set_keymap(bufnr, "n", "pc", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
	buf_set_keymap(bufnr, "n", "pi", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
	buf_set_keymap(bufnr, "n", "pr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
	buf_set_keymap(bufnr, "n", "<Leader>pn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
	buf_set_keymap(bufnr, "n", "<Leader>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
	buf_set_keymap(bufnr, "x", "<Leader>f", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
	buf_set_keymap(bufnr, "v", "<Leader>f", "<cmd>lua vim.lsp.buf.range_formatting()<CR>", opts)
	buf_set_keymap(bufnr, "n", "<Leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
	buf_set_keymap(bufnr, "x", "<Leader>ca", "<cmd>lua vim.lsp.buf.range_code_action()<CR>", opts)
	buf_set_keymap(bufnr, "v", "<Leader>ca", "<cmd>lua vim.lsp.buf.range_code_action()<CR>", opts)
end
local on_attach = function(_,bufnr)
	keymaps_on_attach(bufnr)
end
for _,lsp in ipairs({"gopls","golangci_lint_ls","dockerls", "jsonls", "yamlls"}) do
	nvim_lsp[lsp].setup{
		on_attach = on_attach,
		capabilities = cmp_nvim_lsp.update_capabilities(vim.lsp.protocol.make_client_capabilities()),
	}
end

nvim_lsp.vimls.setup{
	on_attach = require("aerial").on_attach
}
