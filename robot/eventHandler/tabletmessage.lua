local function me(_, _, from, port, _, message)

local command = require("command/"..tostring(message))
command.do()
end

return me