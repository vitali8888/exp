local function me(command)

local sender = require ("actions/messageSender")
local class = require ("class/singleton")
obj = class.new()

local pos = obj.pC.points[command[2]]

if pos ~= nil then
local message = "X:"..pos.x.." Y:"..pos.y.." Z:"..pos.z

sender(message)
end
end

return me