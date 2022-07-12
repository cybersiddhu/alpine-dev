local nls = require "null-ls"
local sources = { nls.builtins.formatting.golines }
nls.setup({sources = sources})
