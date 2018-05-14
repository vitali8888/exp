local function me(message)
local sender = require("actions/messageSender")
local robot = require ("robot")
if message[2] == robot.name() then
    sender("new connection")
end

end
return me