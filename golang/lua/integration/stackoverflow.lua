local api = vim.api
local M = {}
math.randomseed(os.time())

local function randString(length)
	local rstr = {}
	for _= 1,length
          do
  	    local randLower = string.char(math.random(97, 97 + 25))
	    local randUpper = string.char(math.random(65, 65 + 25))
	    table.insert(rstr,randLower..randUpper)
	end
	return table.concat(rstr)
end
function M.open_split()
	local termFmt = "FloatermNew --title=%s --wintype=float --autoclose=0 --name=%s"
	local termCmd = string.format(termFmt, randString(8), randString(9))
	api.nvim_command(termCmd)
end
return M
