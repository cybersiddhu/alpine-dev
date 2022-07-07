-- lsp and related configuration
local opts = { noremap = true, silent = true}
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, opts)
vim.keymap.set('n', '[c', vim.diagnostic.goto_prev, opts)
vim.keymap.set('n', ']c', vim.diagnostic.goto_next, opts)
vim.keymap.set('n', '<space>q', vim.diagnostic.setqflist, opts)
vim.keymap.set('n', '<space>l', vim.diagnostic.setloclist, opts)

local buf_set_keymap = vim.keymap.set
local nvim_lsp = require "lspconfig"
local cmp_nvim_lsp = require "cmp_nvim_lsp"
local function keymaps_on_attach(bufnr)
	local bufopts = { noremap=true, silent=true, buffer=bufnr }
	buf_set_keymap("n","U", vim.lsp.buf.hover, bufopts)
	buf_set_keymap("n", "S", vim.lsp.buf.signature_help, bufopts)
	buf_set_keymap("n", "pd", vim.lsp.buf.type_definition, bufopts)
	buf_set_keymap("n", "pc", vim.lsp.buf.definition, bufopts)
	buf_set_keymap("n", "pi", vim.lsp.buf.implementation, bufopts)
	buf_set_keymap("n", "pr", vim.lsp.buf.references, bufopts)
	buf_set_keymap("n", "<Leader>pn", vim.lsp.buf.rename, bufopts)
	buf_set_keymap("n", "<Leader>f", vim.lsp.buf.formatting, bufopts)
	buf_set_keymap("x", "<Leader>f", vim.lsp.buf.range_formatting, bufopts)
	buf_set_keymap("v", "<Leader>f", vim.lsp.buf.range_formatting, bufopts)
	buf_set_keymap("n", "<Leader>ca", vim.lsp.buf.code_action, bufopts)
	buf_set_keymap("x", "<Leader>ca", vim.lsp.buf.range_code_action, bufopts)
	buf_set_keymap("v", "<Leader>ca", vim.lsp.buf.range_code_action, bufopts)
end
local on_attach = function(_,bufnr)
	keymaps_on_attach(bufnr)
end
for _,lsp in ipairs({"html","graphql","eslint", "dockerls","yamlls"}) do
	nvim_lsp[lsp].setup{
		on_attach = on_attach,
		capabilities = cmp_nvim_lsp.update_capabilities(vim.lsp.protocol.make_client_capabilities()),
	}
end
local on_attach_tsserver = function(client, bufnr)
	client.resolved_capabilities.document_formatting = false
        client.resolved_capabilities.document_range_formatting = false
	keymaps_on_attach(bufnr)
end
nvim_lsp.tsserver.setup{
	on_attach = on_attach_tsserver,
	capabilities = cmp_nvim_lsp.update_capabilities(vim.lsp.protocol.make_client_capabilities()),
}
nvim_lsp.vimls.setup{
	on_attach = require("aerial").on_attach
}
nvim_lsp.jsonls.setup{
	on_attach = on_attach,
	capabilities = cmp_nvim_lsp.update_capabilities(vim.lsp.protocol.make_client_capabilities()),
	settings = {
    		json = {
      			schemas = require("schemastore").json.schemas(),
      			validate = { enable = true },
    		},
  	},
}
