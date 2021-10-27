local utils = require "utils"
utils.map("n","<Leader>ff","<Cmd>Telescope find_files<CR>")
utils.map("n","<Leader>fl","<Cmd>Telescope git_files<CR>")
utils.map("n","<Leader>fg","<Cmd>Telescope live_grep<CR>")
utils.map("n","<Leader>fh","<Cmd>Telescope help_tags<CR>")
utils.map("n","<Leader>e","<Cmd>Telescope file_browser<CR>")
utils.map("n","<Up>p","<Cmd>Telescope commands<CR>")

