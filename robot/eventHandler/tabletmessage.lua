local me = {}

function me.do(_, _, from, port, _, message)

local command = require("command/"..tostring(message))
command.do()

end

return me