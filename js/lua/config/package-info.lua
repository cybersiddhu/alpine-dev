require("package-info").setup()
local utils = require "utils"
utils.map("n","<Leader>ns","<Cmd>PackeInfoShow<CR>")
utils.map("n","<Leader>nh","<Cmd>PackeInfoHide<CR>")
utils.map("n","<Leader>nu","<Cmd>PackeInfoUpdate<CR>")
utils.map("n","<Leader>ni","<Cmd>PackeInfoInstall<CR>")
utils.map("n","<Leader>nv","<Cmd>PackeInfoChangeVersion<CR>")
