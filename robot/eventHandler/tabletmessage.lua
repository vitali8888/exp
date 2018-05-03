return function(_, _, from, port, _, message)

    local strmes = tostring(message)
    local message = {}
    local i=1
    for w in string.gmatch(strmes, "%w+") do
        message[i] = w
        i = i + 1
    end

    local command = require("command/"..message[1])
    command(message)


end